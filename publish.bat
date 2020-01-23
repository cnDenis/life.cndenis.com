
@rem 生成站点
pelican content -s publishconf.py

@if not %errorlevel% == 0 (
    echo site genaration failed
    goto :eof
)

@rem 读取CNAME
set /P cname=<CNAME

@rem 更新gh-pages分支
ghp-import -c %cname% output

@if not %errorlevel% == 0 (
    echo ghp-import failed
    goto :eof
)

@echo ghp-import ok

@rem 让用户选择是否提交到github
@set /p inp="Push to github? [y/n]:"

@if %inp% == y (
    git push origin gh-pages:gh-pages
)
