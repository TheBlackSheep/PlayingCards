unit cards;
//***********************************************************************
//**  Cards Component                                                  **
//***********************************************************************
//**  This component allows you to produce a variety of card games.    **
//**  The code contained in this document is entirely free to use in   **
//**  both commercial and non-commercial applications.  If this        **
//**  component is utilized in any way, shape, or form, I would        **
//**  appreciate a notification via email indicating this, as well as  **
//**  any comments or suggestions you may have.                        **
//**  I can be reached at:                                             **
//**    elvis@sway.com                                                 **
//**                                Sincerely,                         **
//**                                  T. J. Sobotka                    **
//***********************************************************************
//**  Properties:                                                      **
//**    Card:  Used to select card for individual component.  Custom   **
//**           property editor was required to ensure correct ordering **
//**           in the object inspector.                                **
//**    SelectedCard:  Used to determine the appearance of a card if   **
//**           an alternative is desired to indicate a selected card.  **
//**    ShowCard:  Used to determine whether or not the card has its   **
//**           face or card back showing.                              **
//**    Suit:  Used to select card suit for individual component.      **
//***********************************************************************
//**  modified for use with Lazarus by TheBlackSheep 2012-04-06        **
//***********************************************************************

interface

{$R 'cardres.res'}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  PropEdits,
  Graphics,
  LResources;

const
  DEFAULT_CARD_WIDTH          = 71;
  DEFAULT_CARD_HEIGHT         = 96;

type

  TCardValue =
    (Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King);
  TCardSuit = (Clubs, Diamonds, Hearts, Spades);

  TCardValueEditor = class(TEnumProperty)
  protected
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  ECard = class(Exception);

  TCard = class(TGraphicControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FCardValue: TCardValue;
    FCardSuit: TCardSuit;
    FShowCard: Boolean;
    FSelectedCard: Boolean;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetCardValue(CardValue: TCardValue);
    procedure SetShowCard(CardShowValue: Boolean);
    procedure SetCardSuit(CardSuitValue: TCardSuit);
    procedure SetSelectedCard(CardSelectedValue: Boolean);
  published
    { Published declarations }
    property Card: TCardValue read FCardValue write SetCardValue;
    property SelectedCard: Boolean read FSelectedCard write SetSelectedCard;
    property ShowCard: Boolean read FShowCard write SetShowCard;
    property Suit: TCardSuit read FCardSuit write SetCardSuit;
    property DragMode;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
  end;

procedure Register;

var
  CardInstanceCount: LongInt = 0;
  CardSet: TBitmap;
  CardBack: TBitmap;
  CardMask: TBitmap;
  CardWork: TBitmap;

implementation

constructor TCard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCardValue := Ace;
  if (CardInstanceCount < 1) then
    begin
    CardSet := TBitmap.Create;
    CardMask := TBitmap.Create;
    CardMask.Monochrome := True;
    CardBack := TBitmap.Create;
    CardWork := TBitmap.Create;
    CardWork.Width := DEFAULT_CARD_WIDTH;
    CardWork.Height := DEFAULT_CARD_HEIGHT;
    CardSet.LoadFromResourceName(HInstance, 'CARDSET');
    CardMask.LoadFromResourceName(HInstance, 'CARDMASK');
    CardBack.LoadFromResourceName(HInstance, 'CARDBACK');
    end;
  Inc(CardInstanceCount);
end;

destructor TCard.Destroy;
begin
  Dec(CardInstanceCount);
  if (CardInstanceCount < 1) then
    begin
    CardSet.Free;
    CardMask.Free;
    CardBack.Free;
    CardWork.Free;
    end;
  inherited Destroy;
end;

procedure TCard.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT);
end;

procedure TCard.Paint;
var
  CardPaintMode: Integer;
begin
  BitBlt(CardWork.Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
      Canvas.Handle, 0, 0, SRCCOPY);
  if (FSelectedCard = False) then
    begin
    CardPaintMode := SRCPAINT;
    BitBlt(CardWork.Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
    CardMask.Canvas.Handle, 0, 0, SRCAND);
    end
  else
    begin
    CardPaintMode := NOTSRCERASE;
    BitBlt(CardWork.Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
      CardMask.Canvas.Handle, 0, 0, SRCERASE);
    end;
  case FShowCard of
    True:
      BitBlt(CardWork.Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
        CardSet.Canvas.Handle, (LongInt(FCardValue) * DEFAULT_CARD_WIDTH),
        (LongInt(FCardSuit) * DEFAULT_CARD_HEIGHT), CardPaintMode);
    False:
      BitBlt(CardWork.Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
        CardBack.Canvas.Handle, 0, 0, CardPaintMode);
  end;
  BitBlt(Canvas.Handle, 0, 0, DEFAULT_CARD_WIDTH, DEFAULT_CARD_HEIGHT,
    CardWork.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TCard.SetCardValue(CardValue: TCardValue);
begin
  FCardValue := CardValue;
  case FShowCard of
    True:
      Repaint;
    False:;
  end;
end;

procedure TCard.SetSelectedCard(CardSelectedValue: Boolean);
begin
  if (FSelectedCard <> CardSelectedValue) then
    begin
    FSelectedCard := CardSelectedValue;
    Repaint;
    end;
end;

procedure TCard.SetShowCard(CardShowValue: Boolean);
begin
  if (FShowCard <> CardShowValue) then
    begin
    FShowCard := CardShowValue;
    Repaint;
    end;
end;

procedure TCard.SetCardSuit(CardSuitValue: TCardSuit);
begin
  FCardSuit := CardSuitValue;
  case FShowCard of
    True:
      Repaint;
    False:;
  end;
end;

function TCardValueEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TCardValueEditor.GetValues(Proc: TGetStrProc);
begin
  Proc('Ace');
  Proc('Two');
  Proc('Three');
  Proc('Four');
  Proc('Five');
  Proc('Six');
  Proc('Seven');
  Proc('Eight');
  Proc('Nine');
  Proc('Ten');
  Proc('Jack');
  Proc('Queen');
  Proc('King');
end;

function TCardValueEditor.GetValue: string;
begin
  case GetOrdValue of
    LongInt(Ace): Result := 'Ace';
    LongInt(Two): Result := 'Two';
    LongInt(Three): Result := 'Three';
    LongInt(Four): Result := 'Four';
    LongInt(Five): Result := 'Five';
    LongInt(Six): Result := 'Six';
    LongInt(Seven): Result := 'Seven';
    LongInt(Eight): Result := 'Eight';
    LongInt(Nine): Result := 'Nine';
    LongInt(Ten): Result := 'Ten';
    LongInt(Jack): Result := 'Jack';
    LongInt(Queen): Result := 'Queen';
    LongInt(King): Result := 'King';
  end;
end;

procedure TCardValueEditor.SetValue(const Value: string);
begin
    if (Value = 'Ace') then SetOrdValue(LongInt(Ace));
    if (Value = 'Two') then SetOrdValue(LongInt(Two)) ;
    if (Value = 'Three') then SetOrdValue(LongInt(Three)) ;
    if (Value = 'Four') then SetOrdValue(LongInt(Four)) ;
    if (Value = 'Five') then SetOrdValue(LongInt(Five)) ;
    if (Value = 'Six') then SetOrdValue(LongInt(Six)) ;
    if (Value = 'Seven') then SetOrdValue(LongInt(Seven)) ;
    if (Value = 'Eight') then SetOrdValue(LongInt(Eight)) ;
    if (Value = 'Nine') then SetOrdValue(LongInt(Nine)) ;
    if (Value = 'Ten') then SetOrdValue(LongInt(Ten)) ;
    if (Value = 'Jack') then SetOrdValue(LongInt(Jack)) ;
    if (Value = 'Queen') then SetOrdValue(LongInt(Queen)) ;
    if (Value = 'King') then SetOrdValue(LongInt(King)) ;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TCardValue), TCard, '', TCardValueEditor);
  RegisterComponents('Cards', [TCard]);
end;

initialization
  {$I tcard.lrs}
end.
 
