import sys
try:
    import markdown
    res = f"YES, version {markdown.__version__}"
except ImportError:
    res = "NO"
with open("output/md_result.txt", "w") as f:
    f.write(res)
