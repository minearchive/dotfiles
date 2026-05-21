{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = "set -g fish_greeting";
    functions = {
      tex = {
        body = ''
          if test -z "$argv[1]"
              echo "Usage: tex 'e^{i\pi} + 1 = 0'"
              return 1
          end

          # 背景指定を削除し、透過 (\bg_transparent) に戻しました
          set -l encoded (printf "%s" "$argv[1]" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote('\\\\dpi{300} \\\\color{white} ' + sys.stdin.read()))")

          curl -s "https://latex.codecogs.com/png.latex?$encoded" | kitten icat --stdin yes
        '';
      };
      typ = {
        body = ''
                    if test -z "$argv[1]"
                        echo "Usage: typ 'e^(i pi) + 1 = 0'"
                        return 1
                    end

                    set -l tmpdir (mktemp -d /tmp/typst_XXXXXX)
                    printf "#set page(width: auto, height: auto, margin: 10pt, fill: none)
          #set text(fill: white, size: 20pt)
          \$ %s \$" "$argv[1]" > "$tmpdir/f.typ"

                    typst compile "$tmpdir/f.typ" "$tmpdir/f.png" --ppi 300

                    echo $tmpdir

                    set -l out (command ls "$tmpdir"/f*.png 2>/dev/null | head -1)
                    if test -n "$out"
                        cat "$out" | kitten icat --stdin yes
                    else
                        echo "Error: Failed to render Typst formula. Make sure 'typst' is installed."
                    end
                    rm -rf "$tmpdir"
        '';
      };
    };
  };

  home.file.".bashrc" = {
    text = ''
            function tex() {
                if [ -z "$1" ]; then
                    echo "Usage: tex 'e^{i\pi} + 1 = 0'"
                    return 1
                fi
                local encoded=$(printf "%s" "$1" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote('\\\\dpi{300} \\\\color{white} ' + sys.stdin.read()))")
                curl -s "https://latex.codecogs.com/png.latex?''${encoded}" | kitten icat --stdin yes
            }
            function typ() {
                if [ -z "$1" ]; then
                    echo "Usage: typ 'e^(i pi) + 1 = 0'"
                    return 1
                fi
                local tmpdir=$(mktemp -d /tmp/typst_XXXXXX)
                printf "#set page(width: auto, height: auto, margin: 10pt, fill: none)
      #set text(fill: white, size: 20pt)
      \$ %s \$" "$1" > "$tmpdir/f.typ"
                typst compile "$tmpdir/f.typ" "$tmpdir/f.png" --ppi 300
                local out=$(ls "$tmpdir"/f*.png 2>/dev/null | head -1)
                if [ -n "$out" ]; then
                    cat "$out" | kitten icat --stdin yes
                else
                    echo "Error: Failed to render Typst formula. Make sure 'typst' is installed."
                fi
                rm -rf "$tmpdir"
            }
    '';
  };
}
