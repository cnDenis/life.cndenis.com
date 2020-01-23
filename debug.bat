
@rem 生成站点
pelican content

@if not %errorlevel% == 0 (
    echo site genaration failed
    goto :eof
)

cd output
python -m http.server --cgi 8000
