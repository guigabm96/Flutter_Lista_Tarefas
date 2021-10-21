import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // serve para identificar o diretorio no ios ou android
import'dart:io';
import'dart:async';
import 'dart:convert';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();


 Future<File> _getFile()async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json"); // indica onde será salvo os dados

  }
  _salvarTarefa (){
    String textoDigitado = _controllerTarefa.text;

    //Criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"]= textoDigitado;
    tarefa["realizada"]= false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
     _salvarArquivo();
     _controllerTarefa.text = ""; //limpa a caixa de texto do alertDialog
  }


  _salvarArquivo() async{
      var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo()async{

    try{
      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lerArquivo().then((dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }



  @override
  Widget build(BuildContext context) {

   //_salvarArquivo();
    print("itens:"+_listaTarefas.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 10,
        backgroundColor:Colors.purple,
        onPressed: (){

          showDialog(context: context,
              builder: (context){

                return AlertDialog(
                  title:Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(
                        labelText: "Digite sua tarefa" ),
                    onChanged: (text){

                    },
                  ),
                  actions: <Widget>[
                    FlatButton(onPressed: () => Navigator.pop(context), // fecha o alertDialog
                        child: Text("Cancelar")
                    ),
                    FlatButton(onPressed: (){
                      //salvar
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                        child: Text("Salvar")
                    ),
                  ],
                );
              });
        },
      ),
      body: Column(
        children: <Widget>[

          Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                  itemBuilder: (context,index){

                  return CheckboxListTile(
                    title: Text(_listaTarefas[index]['titulo']),
                      value: _listaTarefas[index]['realizada'],
                      onChanged: (valorAlterado){

                      setState(() {
                        _listaTarefas[index]['realizada'] = valorAlterado;
                      });

                       _salvarArquivo();
                      });
                  /*
                  return ListTile(

                  );*/

                  }),
              )

        ],
      ),
    );
  }
}
