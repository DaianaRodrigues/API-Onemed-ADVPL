#include "protheus.ch"

/*
+===========================================+
| Programa: Classe feita para os dados do enfermeiro |
| Autor : Daiana Rodrigues Nascimento |
| Data : 09/03/23 |
+===========================================+
*/

Class PLEnfermeiro
    PRIVATE DATA nId 
    PRIVATE DATA cNome
    PRIVATE DATA cEmail
    PRIVATE DATA nCre
    PRIVATE DATA nCpf
    PRIVATE DATA nTelefone
    PRIVATE DATA cMensagem

    PUBLIC METHOD New() CONSTRUCTOR
    PUBLIC METHOD save(oDados)
    PUBLIC METHOD gravar()
    PUBLIC METHOD mensagem()
    PUBLIC METHOD getEnfermeiro()

endclass

METHOD new() Class PLEnfermeiro
    Self:cNome := ""
    Self:cEmail := ""
    Self:nCre := 0
    Self:nCpf := 0
    Self:nTelefone := 0
    Self:cMensagem := ""

return Self

METHOD save(oDados) Class PLEnfermeiro
    Local lOk := .F.
    Self:cNome := oDados["nome"]
    Self:cEmail := oDados["email"]
    Self:nCre := oDados["cre"]
    Self:nCpf := oDados["cpf"]
    Self:nTelefone := oDados["telefone"]

    ZZ4->(DbSetorder(2))

    Do Case

        Case empty(oDados["nome"])
            Self:cMensagem := EncodeUtf8("Obrigatório informar o nome!")

        Case empty(oDados["cpf"])
            Self:cMensagem := EncodeUtf8("Obrigatório informar o cpf!")

        Case empty(oDados["cre"])
            Self:cMensagem := EncodeUtf8("Obrigatório informar o cre!")

        Case empty(oDados["email"])
            Self:cMensagem := EncodeUtf8("Obrigatório informar o email!")

        Case ValType(oDados["cpf"]) != "C"
            Self:cMensagem := 'O cpf tem que ser caracter!'

        Case ValType(oDados["cre"]) != "N"
            Self:cMensagem := EncodeUtf8("O cre tem que ser numérico!")

        Case ValType(oDados["nome"]) != "C"
            Self:cMensagem := 'O nome tem que ser um caractere!'

        Case ValType(oDados["telefone"]) != "C"
            Self:cMensagem := 'O telefone tem que ser caractere!'

        Case ZZ4->(DbSeek(xFilial("ZZ4")+oDados["cpf"]))
            Self:cMensagem := EncodeUtf8('CPF já cadastrado!')
       
        OtherWise

            Self:gravar()
            lOk := .T.
    EndCase
return lOk

METHOD gravar() Class PLEnfermeiro
    chkfile("ZZ4")
    ZZ4->(RecLock("ZZ4", .T.))
    ZZ4->ZZ4_ID := GETSX8NUM("ZZ4", "ZZ4_ID")
    ZZ4->ZZ4_NOME := Self:cNome
    ZZ4->ZZ4_EMAIL := Self:cEmail
    ZZ4->ZZ4_CRE := Self:nCre
    ZZ4->ZZ4_CPF := Self:nCpf
    ZZ4->ZZ4_TELEFO := Self:nTelefone

    ZZ4->(MsUnlock())
    ZZ4->(ConfirmSX8())
return .T.

METHOD mensagem() Class PLEnfermeiro
    
return Self:cMensagem

METHOD getEnfermeiro() Class PLEnfermeiro
    Local aEnfermeiros := {}
    Local oEnfermeiro := {}
    Local oJson := JsonObject():new()
    DbSelectArea("ZZ4")
    ZZ4->(DbGoTop())

    While ZZ4->(!EOF())

    oEnfermeiro := JsonObject():new()
    oEnfermeiro["nome"] := Alltrim(ZZ4->ZZ4_NOME)
    oEnfermeiro["cre"] := ZZ4->ZZ4_CRE
    oEnfermeiro["cpf"] := Alltrim(ZZ4->ZZ4_CPF)
    oEnfermeiro["email"] := Alltrim(ZZ4->ZZ4_EMAIL)
    oEnfermeiro["telefone"] := Alltrim(ZZ4->ZZ4_TELEFO)
  
    aAdd(aEnfermeiros, oEnfermeiro)

    FreeObj(oEnfermeiro)
    oEnfermeiro := Nil

    ZZ4->(dbskip())
    EndDo

    ZZ4->(DbCloseArea())

    oJson["enfermeiros"] := aEnfermeiros

Return oJson:toJSON()