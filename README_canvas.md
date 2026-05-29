https://stackoverflow.com/questions/71484593/converting-the-html-page-to-a-downloadable-pdf-with-a-button-click

https://ekoopmans.github.io/html2pdf.js/#page-breaks

https://parzibyte.github.io/ejemplos-javascript/html-a-pdf/

https://stackoverflow.com/questions/74704039/html2pdf-page-break-with-spacing-page-numbers

https://github.com/spipu/html2pdf

https://github.com/spipu/html2pdf/tree/master/examples

https://github.com/spipu/html2pdf/blob/master/doc/basic.md

https://github.com/spipu/html2pdf/blob/master/doc/page.md

https://stackoverflow.com/questions/44434797/page-break-after-page-break-after-property-for-div-elements

https://github.com/spipu/html2pdf/blob/master/doc/font.md

https://stackoverflow.com/questions/53227806/print-hidden-div-of-visibilitycollapse-to-pdf

https://stackoverflow.com/questions/67528593/how-add-page-numbers-use-html2pdf

https://www.codexworld.com/convert-html-to-pdf-using-javascript-jspdf/

https://stackoverflow.com/questions/72951034/html2pdf-how-to-prevent-table-row-from-breaking-midway

https://github.com/eKoopmans/html2pdf.js/issues/83

https://github.com/mileszs/wicked_pdf/issues/581

https://scoobyvuu.medium.com/uploading-a-file-to-a-rails-backend-9a5dd4ff56f


https://www.codeply.com/go/QCTo1v0BGj/html2canvas-example

https://jsfiddle.net/26ute5y9/1/

https://jsfiddle.net/dz35v2h1/

https://www.youtube.com/watch?v=dVbDkWbHX6M

https://stackoverflow.com/questions/13623953/how-to-implement-ajax-pagination-with-will-paginate-gem

https://www.freakyjolly.com/convert-html-document-into-image-jpg-png-from-canvas/#google_vignette

https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css


OJOOOO

transformer.chromatographicals.where("deleted=0").order("date_rehearsal DESC").last(1).each do |chromatographical|%>

DEBE SER

transformer.chromatographicals.where("deleted=0").order("date_rehearsal DESC").first(1).each do |chromatographical|%>


EL PROBLEMA ESTA EN LOS WORDS DE REPORT









___________________________


50 x 4 horas

200 cada archivo aprox

4500


LOGIN
PERMISOS

TABLA USUARIOS
TABLA DE EMPRESAS
TABLA DE FORMATOS 

estaciones


actividades


en cada estacion hay documentos ast, inspeccion de planta por cada trabajo

10 a 15 hojas por cacda estacion




_____________________________

cutnas estaciones hay? Son fijas 
las estaciones son estables? Si

Son 10.
______________________________

cuantos tipos de trbajo hay
30 tipos otros y que digiten.....

hay multiples trabajos en una estacion
______________________________


total de formatos: hasta 10 a 15. por actividad

_______________________________

supervisor de planta: revisa que estan avanzando
responsable: llena los datos
seguridad
___________________________________________________

formatos diarios:

___________________
varios trabajos en un dia Fechas y HORA
________________________________________________

No trabajar hastas
teners dos validacioens la 
Formato no puede editarse el formato principal


___________________


seguridad
_____________________


informacion tecnica
______________________

proveedores y trabsadores







________________________________________




     <script>
      document.addEventListener("DOMContentLoaded", () => {
          // Escuchamos el click del botón
          const $boton = document.querySelector("#btnCrearPdf");
          $boton.addEventListener("click", () => {

              var element = document.getElementById('info');
              var opt = {
                  //margin: 1,
                  margin: [0.2, 0.2, 0.2, 0.2],
                  filename: 'myfile.pdf',
                  image: {
                      type: 'png',
                      quality: 0.98
                  },
                   pagebreak: { avoid: "tr", mode: "css", before: "#logo" },
                  html2canvas: {
                      scale: 2,
                      //logging: true,
                      dpi: 192,
                      letterRendering: true
                  },
                  jsPDF: {
                      unit: 'in',
                      format: 'A3',
                      orientation: 'landscape'
                  }
              };
              html2pdf().from(element).set(opt).toPdf().get('pdf').then(function(pdf) {
                  var totalPages = pdf.internal.getNumberOfPages();
                  for (i = 1; i <= totalPages; i++) {
                      pdf.setPage(i);
                      pdf.setFontSize(10);
                      pdf.setTextColor(100);
                      pdf.text('Page ' + i + ' of ' + totalPages, (pdf.internal.pageSize.getWidth() / 2.3), (pdf.internal.pageSize.getHeight() - 0.8));
                  }
              }).save();
              

          });
      });  
     </script>