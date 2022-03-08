# HiveBase

Meu projeto de estudos com o Hive. Qq issue ajuda.

Ainda não esta no formato de um package mas vou atualizar. :-)

# Version 03 (dev)

Ampliá-la, talvez para um package, para conter filtros no padrao do firebase.
```
HiveBase.instance
  .box('users')
  .where('age', isGreaterThan: 20)
  .get()
  .then(...);
```

# Version 02

Implementei um singleton para HiveBase e criei um connection fatory com lock.


# Version 01

Criei uma classe de uso do Hive, chamei-a de HiveBase.


