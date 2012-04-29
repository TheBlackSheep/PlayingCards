unit epicard;

interface

uses
  SysUtils,
  Classes,
  Controls,
  PropEdits,
  Graphics,
  LResources;

type

  TCoverBmp = (Standard, Egypt, Suits, Crystals);

  TCover = (CvBitmap, CvColor);

  TFace = (Up,Down);

  Tsuit = (clubs, diamonds, hearts, spades);

  TEPCard = class(TCustomControl)
  private
    FHoldColor:tcolor;
    Fface:tface;
    FHold:boolean;
    Fdessin: tbitmap;
    FBackColor: tcolor;
    FBackBmp: TCoverBmp;
    Faspect: TCover;
    Fsuit: tsuit;
    Fvalue: byte;
    Frealval: byte;
    { Private declarations }
  protected
    procedure Paint; Override;
    procedure setholdcolor (hldclr:tcolor);
    procedure setvalue(card: byte);
    procedure sethold (hld:boolean);
    procedure setsuit(cardsuit: tsuit);
    procedure setcover(asp: TCover);
    procedure setbackbmp(back: TCoverBmp);
    procedure setcolor(clr: tcolor);  override;
    procedure setface (fce:tface);
    procedure dessine(valeur: byte; sorte: tsuit);
    { Protected declarations }
  public
    Sort: byte;
    property Canvas;
    constructor Create(aowner: tcomponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property HoldColor: tcolor read fholdcolor write setholdcolor default Clblue;
    property Width;
    property Height;
    property Cover: TCover read faspect write setcover default CvBitmap;
    property Face: TFace read fface write setface default Up;
    property CoverBmp: TCoverBmp read Fbackbmp write setbackbmp;
    property Value: byte read fvalue write setvalue default 2;
    property Suit: tsuit read fsuit write setsuit default clubs;
    property RealVal: byte read frealval write frealval default 0;
    property CoverColor: tcolor read fbackcolor write setcolor default clMaroon;
    property Hold:boolean read fhold write sethold default false;
    property Name;
    property OnClick;
    property Dragmode;
    property OnDragDrop;
    property OnDblClick;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Showhint;
    property Visible;
    { Published declarations }
  end;

procedure Register;
{$R epicard.RES}

implementation

destructor TEPCard.Destroy;
begin
  fdessin.free;
  inherited destroy;
end;

procedure TEPCard.sethold (hld:boolean);
begin
  if hld <> fhold then begin
    fhold:=hld;
    invalidate;
  end;
end;

procedure TEPCard.dessine(valeur: byte; sorte: tsuit);
var
  s: string;
  rectangle:trect;
begin
  if fface = up then begin
    case sorte Of
      clubs: s := 'C';
      diamonds: s := 'D';
      hearts: s := 'H';
      spades: s := 'S';
    end;
    s := s + inttostr(valeur);
    fdessin.loadfromresourcename(hinstance, s);
    if fhold=true then begin
      with fdessin do begin
      Canvas.Font.name:='Arial black';
      canvas.Font.size:=16;
      Canvas.Font.Color:=fholdcolor;
      Canvas.Font.Style:=[fsbold];
      Canvas.Brush.Style:=bsclear;
      canvas.TextOut(1,30,'HOLD')  ;
      end;
    end;
  end
  else
  begin
    if faspect = Cvcolor Then begin
      fdessin.free;
      fdessin := tbitmap.create;
      fdessin.height := height; fdessin.width := width;
      fdessin.Canvas.Brush.color := fbackcolor;
      fdessin.canvas.rectangle(0, 0, width, height);
       End
    else begin
      Case fbackbmp Of
        Standard: s := 'standard';
        Egypt: s := 'egypt';
        Crystals: s := 'crystals';
        Suits: s := 'suits';
      end;
      fdessin.LoadFromResourceName(hinstance, s);
    end;
  end;
  with rectangle do begin
    left:=0;right:=width;bottom:=height;top:=0;
  end;
  canvas.stretchdraw(rectangle, fdessin);
 end;

procedure TEPCard.setface (fce:tface);
begin
  if fce <> fface then begin
    fface:=fce;
    invalidate;
  end;
end;

procedure TEPCard.setbackbmp(back: TCoverBmp);
begin
  If back <> fbackbmp then begin
    fbackbmp := back;
    invalidate;
  end;
end;

procedure TEPCard.setholdcolor(hldclr: tcolor);
begin
  If hldclr <> fholdcolor then begin
    fholdcolor := hldclr;
    invalidate;
  end;
end;

procedure TEPCard.setcolor(clr: tcolor);
begin
  if clr <> fbackcolor then begin
    fbackcolor := clr;
    invalidate;
  end;
end;


procedure TEPCard.setvalue(card: byte);
begin
  if (card < 15) and (card > 1) then begin
    if card <> fvalue then begin
      fvalue := card;
      invalidate;
    end;
  end;
end;

procedure TEPCard.setcover(asp: TCover);
begin
  if asp <> faspect then begin
    faspect := asp;
    invalidate;
  end;
end;

procedure TEPCard.setsuit(cardsuit: tsuit);
begin
  if cardsuit <> fsuit then begin
    fsuit := cardsuit;
    invalidate;
  end;
end;

constructor TEPCard.create(aowner: tcomponent);
begin
  inherited create(aowner);
  ControlStyle := ControlStyle + [csOpaque];
  fdessin := tbitmap.create;
  fsuit := clubs;
  fvalue := 2;
  left := 10;
  top := 10;
  faspect := CvBitmap;
  Fface:=up;
  fholdcolor:=clblue;
  fbackcolor := clMaroon;
  width := 71;
  height := 96;
end;

procedure TEPCard.Paint;
begin
  inherited;
  dessine(fvalue, fsuit);
end;

procedure Register;
begin
  RegisterComponents('Cards',[TEPCard]);
end;

initialization
  {$I tepcard.lrs}
end.

