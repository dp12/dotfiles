echo "$(($(cat ~/.p_depth) + 1))" > ~/.p_depth
if [ -f ~/.p_hidden ]; then
  depth=$(($(cat ~/.p_depth)+1))
  (cd $1; find . -maxdepth $depth -type d)
else
  (cd $1; find ./*/ -maxdepth $(cat ~/.p_depth) -type d -not -path '*/\.*')
fi
