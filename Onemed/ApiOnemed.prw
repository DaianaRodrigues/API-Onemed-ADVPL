#include "protheus.ch"
#include "restful.ch"

/*
+===========================================+
| Programa: API para cadastro de enfermeiros |
| Autor : Daiana Rodrigues Nascimento |
| Data : 09/03/23 |
+===========================================+
*/

WsRestFul ONEMED Description "Serviços API para realizar cadastro de enfermeiros" Format APPLICATION_JSON
    WSData apiVersion as STRING OPTIONAL
    WSMethod POST cadEnferm Description "API criada para cadastrar enfermeiros" ;
    WSSyntax "{apiVersion}/enfermeiro" ;
    Path "{apiVersion}/enfermeiro" PRODUCES APPLICATION_JSON

    WSMethod GET getEnferm Description "API criada para retornar cadastro de enfermeiros" ;
    WSSyntax "{apiVersion}/enfermeiro" ;
    Path "{apiVersion}/enfermeiro" PRODUCES APPLICATION_JSON
End WsRestFul

WSMethod POST cadEnferm WSService ONEMED
    Local cBody := ::getContent()
    Local oDados := jsonObject():new()
    Local oEnfermeiro := PLEnfermeiro():new()
    oDados:fromJson(cBody)

    IF oEnfermeiro:save(oDados)
    ::setResponse('{"mensagem" : " '+ EncodeUtf8("Operação realizada com sucesso!") +'" }')
    ELSE
    ::setResponse('{"mensagem" : " '+ oEnfermeiro:mensagem()+'"}')
    ENDIF

return .T.

WSMethod GET getEnferm WSService ONEMED
    Local oEnfermeiro := PLEnfermeiro():new()

    ::setResponse(oEnfermeiro:getEnfermeiro())

return .T.
