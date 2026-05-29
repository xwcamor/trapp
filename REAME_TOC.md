https://github.com/mileszs/wicked_pdf/issues/102

https://github.com/mileszs/wicked_pdf/issues/756

https://github.com/image-charts/ruby

https://editor.image-charts.com/?tab_editor=gallery&tab_viewer=html#https:/image-charts.com/chart?chbr=20&chco=CFECF7%2C27c9c2&chd=a%3A10000%2C50000%2C60000%2C80000%2C40000%7C50000%2C60000%2C100000%2C40000%2C20000&chdl=N%7CN-1&chdlp=r&chl=10%7C50%7C60%7C80%7C40%7C50%7C60%7C100%7C40%7C20&chs=700x450&cht=bvs&chtt=Revenue%20per%20month&chxl=0%3A%7CJan%7CFev%7CMar%7CAvr%7CMay&chxs=1N%2AcUSD0sz%2A%2C000000%2C14&chxt=x%2Cy

https://stackoverflow.com/questions/49805996/generating-a-chartjs-chart-on-the-backend-with-ruby-on-rails

https://chartkick.com/
//= require chartkick
//= require Chart.bundle
https://stackoverflow.com/questions/26342516/chartkick-charts-do-not-show-when-rendering-to-pdf-using-wicked-pdf

http://docs.charturl.com/?ruby#who-are-these-docs-for

https://dynapictures.com/blog/how-to-generate-images-using-url-parameters

https://quickchart.io/documentation/faq/

https://developers.google.com/chart/image/docs/making_charts?hl=es-419

https://quickchart.io/documentation/assets/images/editor-c4e65b8c648ca61bb2175c6868696892.png

https://github.com/typpo/quickchart-ruby





A chart template is a no-code API endpoint that allows you to customize your chart based on its URL. This endpoint generates chart images based on your template that can be used anywhere.

Your chart's API endpoint is:

https://quickchart.io/chart/render/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a
This chart will expire in 60 days if not used. To keep it longer, upgrade to a paid plan.

How to use it
Override the chart template by adding variables to your URL. For example, to override the first dataset, add numbers to data1:

https://quickchart.io/chart/render/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a?data1=50,40,30,20
To override chart labels, set labels:

https://quickchart.io/chart/render/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a?labels=Q1,Q2,Q3,Q4
To override the chart title, set title:

https://quickchart.io/chart/render/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a?title=An interesting chart
You can join multiple overrides by using &:

https://quickchart.io/chart/render/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a?title=An interesting chart&labels=Q1,Q2,Q3,Q4&data1=50,40,30,20


https://quickchart.io/chart/render/zm-13a6e1eb-bffe-44ae-885c-c2b27c1e59ea?title=An%20interesting%20chart&labels=Q1,Q2,Q3,Q4&data1=50,20,30,2

Save this URL to edit your chart later:

https://quickchart.io/chart-maker/edit/zm-0cce24e3-2e46-42de-a6eb-2e40fa8adb6a


