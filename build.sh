#!/bin/bash

# Configurable paths and files
SRC_DIR="src"
OUT_DIR="docs"
HEADER_TEMPLATE="header.html"
FOOTER_TEMPLATE="footer.html"
LIGHT_THEME="catppuccin-latte.css"
DARK_THEME="catppuccin-mocha.css"
SITE_NAME="Basker"

# Create the output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Array to hold the post list items for index page
declare -a posts

# Store posts with their dates for sorting
declare -A post_dates
declare -A post_titles
declare -A post_descriptions

# Process each Markdown file in the source directory
for mdfile in "$SRC_DIR"/*.md; do
    # Use basename without extension for generating output file names
    base=$(basename "$mdfile" .md)

    # Extract metadata from YAML front matter
    title=$(grep -m 1 "^title:" "$mdfile" | sed 's/^title:[[:space:]]*//')
    description=$(grep -m 1 "^description:" "$mdfile" | sed 's/^description:[[:space:]]*//')
    
    # Check if date exists in the file, otherwise use current date
    date_line=$(grep -m 1 "^date:" "$mdfile")
    if [ -z "$date_line" ]; then
        # No date found, add current date to the file in ISO 8601 format (YYYY-MM-DD)
        iso_date=$(date -I)
        # Create a temporary file with the date added
        sed '/^---$/a\
date: '"$iso_date" "$mdfile" > "$mdfile.tmp"
        mv "$mdfile.tmp" "$mdfile"
        post_date="$iso_date"
    else
        # Date found, extract it (might be in old format)
        post_date=$(echo "$date_line" | sed 's/^date:[[:space:]]*//')
        # Check if it's not in ISO format and try to convert it
        if [[ ! "$post_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            # If date can't be parsed as ISO, use file modification time
            iso_date=$(date -I -r "$mdfile")
            # Update the file with ISO date
            sed -i "s/^date:.*$/date: $iso_date/" "$mdfile"
            post_date="$iso_date"
        fi
    fi

    # Set the output file name
    output_file="$OUT_DIR/$base.html"

    # Build the HTML page by concatenating header, converted markdown content, and footer.
    # First strip YAML frontmatter before passing to cmark
    (
        # Replace the site name placeholder with the actual site name
        sed "s/__SITE_NAME__/$SITE_NAME/g" "$HEADER_TEMPLATE"
        
        # Strip YAML frontmatter (content between --- markers) and convert markdown to HTML
        awk 'BEGIN {frontmatter=0; content=0} 
            /^---$/ { 
                if (frontmatter == 0) {
                    frontmatter=1;
                } else {
                    frontmatter=0;
                    content=1;
                }
                next;
            }
            content == 1 { print }' "$mdfile" | cmark
            
        cat "$FOOTER_TEMPLATE"
    ) > "$output_file"

    # Store post data for sorting
    post_dates["$base"]="$post_date"
    post_titles["$base"]="$title"
    post_descriptions["$base"]="$description"
done

# Sort posts by date (newest first)
sorted_posts=()
for post in "${!post_dates[@]}"; do
    sorted_posts+=("$post:${post_dates[$post]}")
done

# Sort the array in reverse chronological order
IFS=$'\n'
sorted_posts=($(printf "%s\n" "${sorted_posts[@]}" | sort -r -t: -k2))
unset IFS

# Create post list items in sorted order with only title and date
for post_info in "${sorted_posts[@]}"; do
    post=${post_info%%:*}
    date=${post_info#*:}
    title=${post_titles[$post]}
    # Format the display date in a more user-friendly way while keeping ISO date for sorting
    display_date=$(date -d "$date" "+%d %B %Y")
    posts+=("<li><a href=\"$post.html\">$title</a><p class=\"date\">$display_date</p></li>")
done

# Generate the index page
index_file="$OUT_DIR/index.html"
(
cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Fauna+One&display=swap" rel="stylesheet">
    <!-- Default to dark theme -->
    <link id="theme-stylesheet" rel="stylesheet" href="$DARK_THEME">
    <script>
        function toggleTheme() {
            var sheet = document.getElementById('theme-stylesheet');
            if (sheet.getAttribute('href') === '$DARK_THEME') {
                sheet.setAttribute('href', '$LIGHT_THEME');
            } else {
                sheet.setAttribute('href', '$DARK_THEME');
            }
        }
    </script>
</head>
<body>
<header>
    <div class="site-name"><a href="index.html">$SITE_NAME</a></div>
    <label class="toggle">
        <input type="checkbox" onclick="toggleTheme()" checked>
        <span class="slider round"></span>
    </label>
</header>
<main>
    <h1>Posts</h1>
    <ul>
EOF
) > "$index_file"

# Append each post list item to the index page
for post in "${posts[@]}"; do
    echo "$post" >> "$index_file"
done

# Append the closing HTML for the index page
(
cat <<EOF
    </ul>
</main>
<footer>
    <p>Static site generated by build.sh</p>
</footer>
</body>
</html>
EOF
) >> "$index_file"

# Copy CSS files and error page to the output directory
cp "$LIGHT_THEME" "$DARK_THEME" "error.html" "$OUT_DIR"/

echo "Site generated in $OUT_DIR"

