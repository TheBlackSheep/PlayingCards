{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit cardset;

interface

uses
  cards, EPICARD, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('cards', @cards.Register);
  RegisterUnit('EPICARD', @EPICARD.Register);
end;

initialization
  RegisterPackage('cardset', @Register);
end.
