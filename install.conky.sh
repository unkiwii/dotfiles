echo off
echo + [CONKY] Installing...

$INSTALL conky

rm -rf ~/.conky >& /dev/null
ln -s $(pwd)/conky ~/.conky

rm -rf ~/.conkyrc >& /dev/null
ln -s $(pwd)/conkyrc ~/.conkyrc

echo + [CONKY] Done!
echo on
