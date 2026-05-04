#!/bin/bash
# Build Hugo site and clean up unwanted auto-generated pages
set -e

cd "$(dirname "$0")"

echo "Building Hugo site..."
hugo --destination public --cleanDestinationDir

echo "Cleaning up..."

cd public

# Remove year-based auto section pages (Hugo generates these from post dates)
rm -rf 2018 2020 2023 2>/dev/null || true

# Remove taxonomy section list pages (categories/, tags/ indexes)
rm -f categories/index.html tags/index.html 2>/dev/null || true
rm -rf categories tags 2>/dev/null || true

# Remove post and pages section list pages
rm -f post/index.html pages/index.html 2>/dev/null || true

# Remove archive section index (replaced by /archives.html)
rm -f archive/index.html 2>/dev/null || true

# Remove combined tag pages (composite slugs from YAML array bug)
for f in tag/*.html; do
    [ -f "$f" ] || continue
    slug="$(basename "$f" .html)"
    case "$slug" in
        *-pelican|pelican-*|*-blog|blog-*)
            rm -f "$f"
            rm -rf "tag/$slug"
            ;;
    esac
done

# Remove pagination duplicates (page/1/ is always a duplicate of index)
find . -type d -path "*/page/1" -exec rm -rf {} + 2>/dev/null || true

# Remove pagination for non-root sections (archive, category, tag, post, etc.)
find . -type d -name "page" -not -path "./page" -exec rm -rf {} + 2>/dev/null || true

# Remove post section flat pages
rm -f post.html categories.html tags.html pages.html 2>/dev/null || true

# Remove empty directories
find . -type d -empty -delete 2>/dev/null || true

echo ""
echo "=== Final output files ==="
find . -type f -name "*.html" | sort
echo ""
echo "=== Compared to Pelican URL structure ==="
echo "Expected (Pelican):"
echo "  /post/2018/02/blog_migrated_to_new_site.html"
echo "  /post/2018/03/install_linux_again.html"
echo "  /post/2020/01/something_about_2019_ncov.html"
echo "  /post/2020/04/something_about_2019_ncov_2.html"
echo "  /post/2023/06/deploy_this_blog.html"
echo "  /post/2023/06/something_in_2023.html"
echo "  /category/zhe-teng-dian-nao.html (Pelican used pinyin, Hugo uses Chinese)"
echo "  /category/shi-shi.html"
echo "  /tag/blog.html"
echo "  /tag/pelican.html"
echo "  /tag/ubuntu.html"
echo "  /archive/2018/index.html"
echo "  /archive/2020/index.html"
echo "  /archive/2023/index.html"
echo "  /index.html"
echo "  /archives.html"
echo "  /pages/about.html"
