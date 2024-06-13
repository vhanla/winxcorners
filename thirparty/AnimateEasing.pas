{
  AnimateEasing v1.0.1.0

  Developed by Norbert Mereg

  Description:
    This component is an easing animation value calculator.

  Features:
    - 28 different easing style (in, out, in-out)


  History:
    v1.0.1  2010.06.14 - Added comment to methods
    v1.0.0  2010.05.14 - First release.
}
unit AnimateEasing;

interface

uses
  SysUtils, DateUtils, Math, Classes, StdCtrls, ExtCtrls;

type
  TEasingFunction = function(p: Extended; firstNum, diff: integer): Extended of object;
  TAnimateTickEvent = reference to procedure(Sender: TObject; Value: Extended);
  TANotifyEvent = reference to procedure(Sender: TObject);

  TResultArray = array of Extended;

  TEasingType = (etBackEaseIn, etbackEaseOut, etBackEaseInOut,
                 etBounceEaseIn, etBounceEaseOut,
                 etCircEaseIn, etCircEaseOut, etCircEaseInOut,
                 etCubicEaseIn, etCubicEaseOut, etCubicEaseInOut,
                 etElasticEaseIn, etElasticEaseOut,
                 etExpoEaseIn, etExpoEaseOut, etExpoEaseInOut,
                 etQuadEaseIn, etQuadEaseOut, etQuadEaseInOut,
                 etQuartEaseIn, etQuartEaseOut, etQuartEaseInOut,
                 etQuintEaseIn, etQuintEaseOut, etQuintEaseInOut,
                 etSineEaseIn, etSineEaseOut, etSineEaseInOut);

  TAnimateEasing = class(TObject)
  private
    FStartPos: integer;
    FAnimLength: integer;
    FDifferent: integer;
    FStartTime: TDateTime;
    FEasingFunc: TEasingFunction;
    FTimer: TTimer;
    FDelayTimer: TTimer;
    FOnTick: TAnimateTickEvent;
    FOnFinish: TANotifyEvent;
    procedure SetOnTick(const Value: TAnimateTickEvent);
    procedure FTimerTimer(Sender: TObject);
    procedure FDelayTimerTimer(Sender: TObject);
    procedure SetOnFinish(const Value: TANotifyEvent);
    procedure FinishAnim;
  public
    constructor Create;
    destructor Destroy; override;

    (*
      This method uses a timer to call the OnTick event with the calculated value.

      StartPos: The animating start value.
      Different: Difference between start and end position.
      Animlength: Full length of animation (millisecond)
      Easing: The animation easing type
      OnTickEvent: The event handler
      CycleTime: The timer cycle time (default 10ms)
      StartDelay: A delay before start the animation
      OnFinishEvent: The event what fire when the animation finished
    *)

    procedure Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType); overload;
    procedure Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType; OnTickEvent: TAnimateTickEvent; OnFinishEvent: TANotifyEvent); overload;
    procedure Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType; CycleTime: integer); overload;
    procedure Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType; CycleTime, StartDelay: integer); overload;
    procedure Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType; CycleTime, StartDelay: integer; OnTickEvent: TAnimateTickEvent; OnFinishEvent: TANotifyEvent); overload;

    procedure StopAnimating;

    (* This method only generate the animation values to an array

      Different: Difference between start and end position.
      StepCount: Count of values
      Easing: The animation easing type *)

    class function GenerateValues(Different, StepCount: integer; Easing: TEasingType): TResultArray;

    (* This method calculate the current value

       p: The animation phase. Values between 0 and 1.
       firstNum: The start values of animation
       diff: Difference between start and end value of animation
    *)
    class function GetEasingFunc(Easing: TEasingType): TEasingFunction; static;
    class function backEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function backEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function backEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function bounceEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function bounceEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function circEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function circEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function circEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function cubicEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function cubicEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function cubicEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function elasticEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function elasticEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function expoEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function expoEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function expoEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function quadEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function quadEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function quadEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function quartEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function quartEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function quartEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function quintEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function quintEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function quintEaseInOut(p: Extended; firstNum, diff: integer): Extended;
    class function sineEaseIn(p: Extended; firstNum, diff: integer): Extended;
    class function sineEaseOut(p: Extended; firstNum, diff: integer): Extended;
    class function sineEaseInOut(p: Extended; firstNum, diff: integer): Extended;
  published
    property OnTick: TAnimateTickEvent read FOnTick write SetOnTick;
    property OnFinish: TANotifyEvent read FOnFinish write SetOnFinish;
  end;


implementation

procedure TAnimateEasing.Animating(StartPos, Different, AnimLength: integer; Easing: TEasingType);
begin
  Animating(StartPos, Different, AnimLength, Easing, 10, -1, nil, nil);
end;

procedure TAnimateEasing.Animating(StartPos, Different, AnimLength: integer;
  Easing: TEasingType; OnTickEvent: TAnimateTickEvent;
  OnFinishEvent: TANotifyEvent);
begin
  Animating(StartPos, Different, AnimLength, Easing, 10, -1, OnTickEvent, OnFinishEvent);
end;

procedure TAnimateEasing.Animating(StartPos, Different, AnimLength: integer;
  Easing: TEasingType; CycleTime: integer);
begin
  Animating(StartPos, Different, AnimLength, Easing, CycleTime, -1, nil, nil);
end;

procedure TAnimateEasing.Animating(StartPos, Different, AnimLength: integer;
  Easing: TEasingType; CycleTime: integer; StartDelay: integer);
begin
  Animating(StartPos, Different, AnimLength, Easing, CycleTime, StartDelay, nil, nil);
end;

procedure TAnimateEasing.Animating(StartPos, Different, AnimLength: integer;
  Easing: TEasingType; CycleTime, StartDelay: integer;
  OnTickEvent: TAnimateTickEvent; OnFinishEvent: TANotifyEvent);
begin
  FEasingFunc := GetEasingFunc(Easing);
  FStartPos := StartPos;
  FStartTime := Now;
  FDifferent := Different;
  FAnimLength := AnimLength;
  if Assigned(OnTickEvent) then OnTick := OnTickEvent;
  if Assigned(OnFinishEvent) then OnFinish := OnFinishEvent;

  FTimer.Enabled := false;
  FTimer.Interval := CycleTime;

  if StartDelay = -1 then
    FTimer.Enabled := true
  else
  begin
    FDelayTimer.Interval := StartDelay;
    FDelayTimer.Enabled := true;
  end;
end;

class function TAnimateEasing.GenerateValues(Different, StepCount: integer;
  Easing: TEasingType): TResultArray;
var
  I: Integer;
  Value: Extended;
  EasingFunc: TEasingFunction;
begin
  if StepCount = 0 then Exit;

  EasingFunc := GetEasingFunc(Easing);
  SetLength(result, StepCount);
  for I := 0 to StepCount - 1 do
  begin
    Value := EasingFunc(I / StepCount, 0, Different);
    result[I] := Value;
  end;
end;



 {$REGION 'Easing functions'}

class function TAnimateEasing.GetEasingFunc(Easing: TEasingType): TEasingFunction;
begin
  case Easing of
    etBackEaseIn: result := BackEaseIn;
    etbackEaseOut: result := backEaseOut;
    etBackEaseInOut: result := BackEaseInOut;
    etBounceEaseIn: result := BounceEaseIn;
    etBounceEaseOut: result := BounceEaseOut;
    etCircEaseIn: result := CircEaseIn;
    etCircEaseOut: result := CircEaseOut;
    etCircEaseInOut: result := CircEaseInOut;
    etCubicEaseIn: result := CubicEaseIn;
    etCubicEaseOut: result := CubicEaseOut;
    etCubicEaseInOut: result := CubicEaseInOut;
    etElasticEaseIn: result := ElasticEaseIn;
    etElasticEaseOut: result := ElasticEaseOut;
    etExpoEaseIn: result := ExpoEaseIn;
    etExpoEaseOut: result := ExpoEaseOut;
    etExpoEaseInOut: result := ExpoEaseInOut;
    etQuadEaseIn: result := QuadEaseIn;
    etQuadEaseOut: result := QuadEaseOut;
    etQuadEaseInOut: result := QuadEaseInOut;
    etQuartEaseIn: result := QuartEaseIn;
    etQuartEaseOut: result := QuartEaseOut;
    etQuartEaseInOut: result := QuartEaseInOut;
    etQuintEaseIn: result := QuintEaseIn;
    etQuintEaseOut: result := QuintEaseOut;
    etQuintEaseInOut: result := QuintEaseInOut;
    etSineEaseIn: result := SineEaseIn;
    etSineEaseOut: result := SineEaseOut;
    etSineEaseInOut: result := SineEaseInOut;
  else
    result := QuartEaseInOut;
  end;
end;

class function TAnimateEasing.backEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, s: Extended;
begin
  c := diff;
  s := 1.70158;
  result :=  c*p*p*((s+1)*p - s) + firstNum; //return c*(p/=1)*p*((s+1)*p - s) + firstNum;
end;

class function TAnimateEasing.backEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, s: Extended;
begin
  c := diff;
  s := 1.70158;
  p := p - 1;
  result :=  c*(p*p*((s+1)*p + s) + 1) + firstNum; //return c*((p=p/1-1)*p*((s+1)*p + s) + 1) + firstNum;
end;

class function TAnimateEasing.backEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, s: Extended;
begin
  c := diff;
  s := 1.70158 * 1.525;
  p := p / 0.5;
  if (p < 1) then
    result := c/2*(p*p*((s + 1)*p - s))  + firstNum //return c/2*(p*p*(((s*=(1.525))+1)*p - s)) + firstNum;
  else
  begin
    p := p - 2;
    result := c/2*(p*p*((s + 1)*p + s) + 2) + firstNum; //return c/2*((p-=2)*p*(((s*=(1.525))+1)*p + s) + 2) + firstNum;
  end;
end;

class function TAnimateEasing.bounceEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, inv: Extended;
begin
  c := diff;
  inv := bounceEaseOut(1 - p, 0, diff);
  result := c - inv + firstNum;
end;

class function TAnimateEasing.bounceEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  if ( p < 1/2.75) then
    result := c*(7.5625*p*p) + firstNum
  else if (p < 2/2.75) then
  begin
    p := p - (1.5/2.75);
    result := c*(7.5625*p*p + 0.75) + firstNum;
  end
  else if (p < 2.5/2.75) then
  begin
    p := p - (2.25/2.75);
    result := c*(7.5625*p*p + 0.9375) + firstNum;
  end
  else
  begin
    p := p - (2.625/2.75);
    result := c*(7.5625*p*p + 0.984375) + firstNum;
  end;
end;

class function TAnimateEasing.circEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  result := -c * (sqrt(1 - p*p) - 1 ) + firstNum; //return -c * (Math.sqrt(1 - (p/=1)*p) - 1) + firstNum;
end;

class function TAnimateEasing.circEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  p := p - 1;
  result := c * sqrt(1 - p*p) + firstNum; //return c * Math.sqrt(1 - (p=p/1-1)*p) + firstNum;
end;

class function TAnimateEasing.circEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  p := p / 0.5;
  if (p < 1) then
    result := -c/2 * (sqrt(1 - p*p) - 1) + firstNum //return -c/2 * (Math.sqrt(1 - p*p) - 1) + firstNum;
  else
  begin
    p := p - 2;
    result := c/2 * (sqrt(1 - p*p) + 1) + firstNum //return c/2 * (Math.sqrt(1 - (p-=2)*p) + 1) + firstNum;
  end;
end;

class function TAnimateEasing.cubicEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  result := c * (p*p*p) + firstNum; //return c*(p/=1)*p*p + firstNum;
end;

class function TAnimateEasing.cubicEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
//  c := diff;
  c := diff;
  p := p -1;
  result := c * (p*p*p + 1) + firstNum; //return c*(p/=1)*p*p + firstNum;
end;

class function TAnimateEasing.cubicEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;
  p := p / 0.5;
  if (p < 1) then
    result := c/2*p*p*p + firstNum //return c/2*p*p*p + firstNum;
  else
  begin
    p := p - 2;
    result := c/2*(p*p*p + 2) + firstNum; //return c/2*((p-=2)*p*p + 2) + firstNum;
  end;
end;

class function TAnimateEasing.elasticEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, period, s, amplitude: Extended;
begin
  c := diff;

  if p = 0 then Exit(firstNum);
  if p = 1 then Exit(c);

  period := 0.25;
  amplitude := c;

  if (amplitude < abs(c)) then
  begin
    amplitude := c;
    s := period / 4;
  end
  else
  begin
    s := period/(2*PI) * Math.ArcSin(c/amplitude);
  end;
  p := p - 1;
  result := -(amplitude*Math.Power(2, 10*p) * sin( (p*1-s)*(2*PI)/period)) + firstNum;
end;

class function TAnimateEasing.elasticEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c, period, s, amplitude: Extended;
begin
  c := diff;

  if diff = 0 then Exit(c); //Divide by zero protect
  if p = 0 then Exit(firstNum);
  if p = 1 then Exit(c);

  period := 0.25;
  amplitude := c;

  if (amplitude < abs(c)) then
  begin
    amplitude := c;
    s := period / 4;
  end
  else
  begin
    s := period/(2*PI) * Math.ArcSin(c/amplitude);
  end;
  result := -(amplitude*Math.Power(2, -10*p) * sin( (p*1-s)*(2*PI)/period)) + c + firstNum;
end;

class function TAnimateEasing.expoEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  if (p = 0) then
    result := firstNum
  else
  begin
    p := p - 1;
    result := c * Math.Power(2, 10*p) + firstNum - c * 0.001;
  end;
end;

class function TAnimateEasing.expoEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  if (p = 1) then
    result := c
  else
  begin
    result := diff * 1.001 * (-Math.Power(2, -10*p) + 1) + firstNum;
  end;
end;

class function TAnimateEasing.expoEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  if (p = 0) then Exit(firstNum);
  if (p = 1) then Exit(c);

  p := p / 0.5;
  if p < 1 then
    result := c/2 * Math.Power(2, 10 * (p-1)) + firstNum - c * 0.0005
  else
  begin
    p := p - 1;
    result := c/2 * 1.0005 * (-Math.Power(2, -10 * p) + 2) + firstNum;
  end;
end;

class function TAnimateEasing.quadEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := c * p*p + firstNum;
end;

class function TAnimateEasing.quadEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := -c * p*(p-2) + firstNum;
end;

class function TAnimateEasing.quadEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  p := p / 0.5;
  if p < 1 then
    result := c/2*p*p + firstNum
  else
  begin
    p := p - 1;
    result := -c/2 * (p*(p-2) - 1) + firstNum;
  end;
end;

class function TAnimateEasing.quartEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := c * p*p*p*p + firstNum;
end;

class function TAnimateEasing.quartEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  p := p - 1;
  result := -c * (p*p*p*p - 1) + firstNum;
end;

class function TAnimateEasing.quartEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  p := p / 0.5;
  if p < 1 then
    result := c/2*p*p*p*p + firstNum
  else
  begin
    p := p - 2;
    result := -c/2 * (p*p*p*p - 2) + firstNum;
  end;
end;

class function TAnimateEasing.quintEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := c * p*p*p*p*p + firstNum;
end;

class function TAnimateEasing.quintEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  p := p - 1;
  result := c * (p*p*p*p*p + 1) + firstNum;
end;

class function TAnimateEasing.quintEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  p := p / 0.5;
  if p < 1 then
    result := c/2*p*p*p*p*p + firstNum
  else
  begin
    p := p - 2;
    result := c/2 * (p*p*p*p*p + 2) + firstNum;
  end;
end;

class function TAnimateEasing.sineEaseIn(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := -c * cos(p*(PI/2)) + c + firstNum;
end;

class function TAnimateEasing.sineEaseOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := c * sin(p*(PI/2)) + firstNum;
end;

class function TAnimateEasing.sineEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  c: Extended;
begin
  c := diff;

  result := -c/2 * (cos(PI*p) - 1) + firstNum;
end;
 {$ENDREGION}

constructor TAnimateEasing.Create;
begin
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := false;
  FTimer.Interval := 10;
  FTimer.OnTimer := FTimerTimer;

  FDelayTimer := TTimer.Create(nil);
  FDelayTimer.Enabled := false;
  FDelayTimer.OnTimer := FDelayTimerTimer;
end;

destructor TAnimateEasing.Destroy;
begin
  FTimer.Free;
  FDelayTimer.Free;

  inherited;
end;


procedure TAnimateEasing.FDelayTimerTimer(Sender: TObject);
begin
  FDelayTimer.Enabled := false;
  FStartTime := Now;
  FTimer.Enabled := true;
end;

procedure TAnimateEasing.FTimerTimer(Sender: TObject);
var
  Value: Extended;
begin
  FTimer.Enabled := false;
  Value := FEasingFunc(MilliSecondsBetween(FStartTime, Now) / FAnimLength, FStartPos, FDifferent);
  if Assigned(OnTick) then
    OnTick(Self, Value);

  if dateUtils.MilliSecondsBetween(FStartTime, Now) < FAnimLength then
  begin
    FTimer.Enabled := true;
  end
  else
  begin
    FinishAnim;
  end;
end;

procedure TAnimateEasing.FinishAnim;
begin
  if Assigned(OnFinish) then
    OnFinish(Self);
end;

procedure TAnimateEasing.StopAnimating;
begin
  FTimer.Enabled := false;
  FDelayTimer.Enabled := false;
  FinishAnim;
end;

procedure TAnimateEasing.SetOnFinish(const Value: TANotifyEvent);
begin
  FOnFinish := Value;
end;

procedure TAnimateEasing.SetOnTick(const Value: TAnimateTickEvent);
begin
  FOnTick := Value;
end;

end.
