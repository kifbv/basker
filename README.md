# 🌟 Basker - A Minimalist Static Site Generator 🌟

## 📝 Overview

Basker is a lightweight static site generator that converts Markdown files into a beautifully styled website using the Catppuccin color theme. It's perfect for blogs, documentation sites, or personal websites that prioritize simplicity and readability.

Check out the live demo at [basker.franckratier.design](https://basker.franckratier.design) to see Basker in action!

## ✨ Features

- 🌓 **Dark/Light Mode Toggle**: Switch between Catppuccin Latte & Mocha themes with a click
- 📱 **Responsive Design**: Looks great on mobile, tablet, and desktop
- 🔤 **Google Fonts**: Uses Cinzel for headings and Fauna One for body text
- 📅 **Automatic Date Handling**: Sorts posts by date and displays them nicely
- 🔄 **Simple Build Process**: One script to generate your entire site

## 🚀 Getting Started

### Prerequisites

- Bash shell
- [cmark](https://github.com/commonmark/cmark) for Markdown processing

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/basker.git
   cd basker
   ```

2. Place your Markdown files in the `src/` directory

3. Run the build script:
   ```bash
   ./build.sh
   ```

4. Your generated site will be in the `docs/` directory, ready to be published as a GitHub Page!

### Deploying on GitHub Pages

1. Push your repository to GitHub:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push
   ```

2. Configure GitHub Pages:
   - Go to your repository on GitHub
   - Navigate to Settings > Pages
   - Under "Source", select "Deploy from a branch"
   - Select "main" branch and "/docs" folder
   - Click "Save"

3. Custom Domain (Optional):
   - In the GitHub Pages settings, enter your custom domain
   - Create/update the `docs/CNAME` file with your domain name
   - Configure your DNS provider with appropriate records:
     - For apex domain: Add A records pointing to GitHub Pages IP addresses
     - For subdomain: Add a CNAME record pointing to `yourusername.github.io`

4. Wait a few minutes for your site to be published. You can check the status in the GitHub Pages section of your repository settings.

## 📄 File Structure

```
basker/
├── build.sh           # Main build script
├── header.html        # Header template
├── footer.html        # Footer template
├── catppuccin-latte.css # Light theme
├── catppuccin-mocha.css # Dark theme
├── src/               # Place your Markdown files here
│   ├── post1.md
│   ├── post2.md
│   └── ...
└── docs/              # Generated HTML and assets
    ├── index.html
    ├── post1.html
    └── ...
```

## 📝 Creating Content

### Markdown Format

Each Markdown file should include YAML frontmatter at the top:

```markdown
---
title: My Awesome Post
description: A brief description of the post
date: 2024-04-03
---

# Main Content Starts Here

Your markdown content goes here...
```

- The `title` appears in the post and index page
- The `description` is used in the index page
- The `date` is used for sorting (will be added automatically if missing)

## 🎨 Customization

### Site Name

Change the `SITE_NAME` variable in `build.sh`:

```bash
SITE_NAME="Your Site Name"
```

### Styling

Modify the CSS files to change the appearance:

- `catppuccin-latte.css` - Light theme
- `catppuccin-mocha.css` - Dark theme

### Fonts

The site uses Google Fonts:
- Cinzel for titles (elegant serif font)
- Fauna One for body text (readable serif font)
- Monospace for code blocks

To change fonts, edit:
1. The Google Fonts import in `header.html`
2. The same import in the index page section of `build.sh`
3. Update the font-family properties in both CSS files

## 🔧 Advanced Usage

### Adding Images

Place image files in the `dist/` directory and reference them in your Markdown:

```markdown
![My Image](image.jpg)
```

### Custom HTML

You can include HTML directly in your Markdown files:

```markdown
<div class="custom-container">
  Custom HTML here
</div>
```

## 📚 Examples

Check out the example posts in the `src/` directory to see how to format your content.

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
