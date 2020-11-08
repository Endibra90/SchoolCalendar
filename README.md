# SchoolCalendar
Widgets Utilizados:
  -GridView(mostrar las asignturas)
  -BottomNavigationBar|Menu(a falta de implementacion)
  -Form(Para pedir los datos de la asignatura)
Modelos utilizados:
  -Cuadro(clase,hora,aula,color)
Api:
  -Apispreadsheets(coge los datos de un excel de drive y los devuelve en forma de API).
Estructura:
  -main.dart=> Es desde donde se inicia la aplicacion y llamo a GridView.
  -grid.dart=> Aqui es donde se encargaria de cargar los datos de la API y representarlos
    Funciones:
      -anadirContainer()=>Funcion que se encarga de que sean contenedores de el modelo Cuadro
      -anadirClaseContenedor()=>Funcion que se encarga de rellenar los cuadrados de los datos de la API.
      -apiRequest()=>Funcion que devuelve los datos de la API.
      -initState()=>Funcion que sirve para hacer lo que sea al iniciar.
      -changeList()=>Funcion que convierte la lista de la API a una lista creada por mi.
      -listaWidget()=>Funcion que se encarga de pintar los cuadros dentro del GridView, que tendran un onTap()para llevarlos al form.dart.
  -form.dart=>
      -changeColor()=>Funcion que repinta el color del colorpicker.
      -sendExcel()=>Funcion que se encarga de volver a escribir la lista en el excel.
      -changeCuadro()=>Funcion que cuando el usuario acepte la clase se encarge de volver a pintar el cuadro seleccionado.
      -main()=>Funcion que llama al main para volver a pintarlo
      -showDialog()=>Se encarga de cuando clickes en el color salga una nueva pestaña para poder seleccionar el color.
  
