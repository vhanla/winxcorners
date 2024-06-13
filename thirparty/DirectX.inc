{******************************************************************************}
{                                                                              }
{ The contents of this file are subject to the Mozilla Public License Version  }
{ 1.1 (the "License"); you may not use this file except in compliance with the }
{ License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ The Original Code is DirectX.inc.                                            }
{                                                                              }
{******************************************************************************}

// Borland compilers support
{$INCLUDE versions.inc}

{$DEFINE TYPE_IDENTITY}
{$DEFINE SUPPORTS_EXCEPTIONS}

// Additional settings
{$MINENUMSIZE 4}
{$ALIGN ON}

{$IFDEF COMPILER7_UP}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
