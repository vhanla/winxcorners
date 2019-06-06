unit GDIPAPIExtra;

interface
uses GDIPAPI;
{ Color functions }
function ARGBMake(const R,G,B : byte) : ARGB; overload;
function ARGBMake(const A,R,G,B : byte) : ARGB; overload;
implementation

// -----------------------------------------------------------------------------
// Color class
// -----------------------------------------------------------------------------

{ ARGB functions }

function ARGBMake(const R,G,B : byte) : ARGB; overload;
begin
  result := ARGB(
              ALPHA_MASK or
              (R shl RED_SHIFT) or
              (G shl GREEN_SHIFT) or
              (B shl BLUE_SHIFT)
            );
end;

function ARGBMake(const A,R,G,B : byte) : ARGB; overload;
begin
  result := ARGB(
              (A shl ALPHA_SHIFT) or
              (R shl RED_SHIFT) or
              (G shl GREEN_SHIFT) or
              (B shl BLUE_SHIFT)
            );
end;

end.
