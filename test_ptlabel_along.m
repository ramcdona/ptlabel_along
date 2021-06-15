clear all
format compact
close all

th = linspace( 0, 360, 181 );
thmark = 0:15:359;
x = cos( th * pi / 180 );
y = sin( th * pi / 180 );
plot( x, y );
axis equal
axis off

ptlabel_along( x, y, th, thmark );

print( 'example.png', '-dpng', '-r300' )
