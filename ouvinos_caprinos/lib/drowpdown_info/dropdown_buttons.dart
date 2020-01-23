class Sexo {
  int id;
  String nome;

  Sexo(this.id, this.nome);

  static List<Sexo> getSex() {
    return <Sexo>[
      Sexo(0,'Não Selecionado'),
      Sexo(1, 'Macho'),
      Sexo(2, 'Fêmea'),
    ];
  }
}

class Categoria{
  int id;
  String nome;

  Categoria(this.id, this.nome);

  static List<Categoria> getCategorias(){
    return <Categoria>[
      Categoria(0,'Não Selecionado'),
      Categoria(1, 'Cria'),
      Categoria(2, 'Recria'),
      Categoria(3, 'Terminação'),
      Categoria(4, 'Matriz'),
      Categoria(5, 'Reprodutor')
    ];

  }
}

class RacaCaprino{
  int id;
  String nome;

  RacaCaprino(this.id, this.nome);

  static List<RacaCaprino> getRacaCaprinos(){
    return <RacaCaprino>[
      RacaCaprino(0,'Não Selecionado'),
      RacaCaprino(1,"NS"),
      RacaCaprino(2,"Alpino"),
      RacaCaprino(3,"Anglo Nubiano"),
      RacaCaprino(4,"Boer"),
      RacaCaprino(5,"Mestiço"),
      RacaCaprino(6,"Saanen"),
      RacaCaprino(7,"Savana"),
      RacaCaprino(8,"Toggenburg"),
    ];
  }

}

class RacaOvino{
  int id;
  String nome;

  RacaOvino(this.id, this.nome);

  static List<RacaOvino> getRacaOvinos(){
    return <RacaOvino>[
      RacaOvino(0,'Não Selecionado'),
      RacaOvino(1,"NS"),
      RacaOvino(2,"Alpino"),
      RacaOvino(3,"Anglo Nubiano"),
      RacaOvino(4,"Boer"),
      RacaOvino(5,"Mestiço"),
      RacaOvino(6,"Saanen"),
      RacaOvino(7,"Savana"),
      RacaOvino(8,"Toggenburg"),
    ];
  }

}