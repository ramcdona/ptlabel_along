function [hl, ht] = ptlabel_along( xc, yc, tc, t, dst, LineSpec )
%PTLABEL_ALONG Label points along a curve with nice offset
%   [HL, HT] = PTLABEL_ALONG( XC, YC, TC, T ) plots and labels points at
%   parameter T along a parametric curve (XC, YC, TC).  The text labels are
%   nicely offset from the curve.
%
%   [HL, HT] = PTLABEL_ALONG( XC, YC, TC, T, DST ) as above, but with the
%   label offset distance fraction specified in DST (0.02).  The offset
%   distance is specified as a fraction of the X-Axis length.  A Positive
%   DST will place the labels on the left side of the curve, negative DST
%   to the right.
%
%   [HL, HT] = PTLABEL_ALONG( XC, YC, TC, T, DST, LINESPEC ) as above, but
%   will plot the desired parametric points with line specifier string
%   LINESPEC ('k.').
%
%   The line or point plot handle is returned in HL.  The text label handle
%   is returned in HT.
%
%   If the data or plot aspect ratios change significantly after the call
%   to PTLABEL_ALONG, the text labels may not look properly offset.
%
%   Example:
%       th = linspace( 0, 360, 181 );
%       thmark = 0:15:359;
%       x = cos( th * pi / 180 );
%       y = sin( th * pi / 180 );
%       plot( x, y );
%       ptlabel_along( x, y, th, thmark );
%
%   See also TEXT, PLOT, DASPECT, PBASPECT.

%   Rob McDonald
%   rob.a.mcdonald@gmail.com
%   15 June      2021 v. 1.0 -- Original version.


% Store hold setting
holdsetting = ishold;

xlog = strcmp( get( gca, 'XScale' ), 'log' );
ylog = strcmp( get( gca, 'YScale' ), 'log' );

% Transform data if in log-space
if ( xlog )
    xc = log( xc );
end

if ( ylog )
    yc = log( yc );
end

% Default offset distance
if ( nargin < 5 )
    dst = 0.02;
end

% Default black dots
if ( nargin < 6 )
    LineSpec = 'k.';
end

% Grab axis limits
ax = axis;
dxax = ax(2)-ax(1);

% Scale offset by plot width
off = dst * dxax;

% Grab aspect ratios to correct scaling
% Data aspect ratio
da = daspect(  );
ard = da( 2 ) / da( 1 );
% Plot aspect ratio (paper space)
pa = pbaspect(  );
arp = pa( 2 ) / pa( 1 );

% Compute overall aspect ratio including 
ar = ard / arp;

% Done handling input options.

tscale = max( tc ) - min( tc );
dt = tscale / 100;

% Find marker points along the parameterized curve
xt = interp1( tc, xc, t );
yt = interp1( tc, yc, t );

% Find vectors in local direction of curve
dxdt = ( interp1( tc, xc, t + dt ) - xt ) ./ dt;
dydt = ( interp1( tc, yc, t + dt ) - yt ) ./ dt ./ ar;

% Normalize direction vector
drdt = sqrt( dxdt.^2 + dydt.^2 );
dxdt = dxdt ./ drdt;
dydt = dydt ./ drdt;

% Offset text orthogonal to curve
xtt = xt - off * dydt;
ytt = yt + off * dxdt * ar;

% Transform back out of log-space
if ( xlog )
    xt = exp( xt );
    xtt = exp( xtt );
end

if ( ylog )
    yt = exp( yt );
    ytt = exp( ytt );
end

hold on

% Plot points and text
hl = plot( xt, yt, LineSpec );
ht = text( xtt, ytt, num2str( t' ), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle'  );

% Restore hold setting
if ( ~holdsetting )
    hold off;
end
