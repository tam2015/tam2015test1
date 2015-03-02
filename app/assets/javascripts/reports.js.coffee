$ ->
  window.reportsGraph = () ->
    Morris.Donut
      element: 'boxes_chart',
      data: [
        {label: $('#boxes_chart').data('label1') , value: $('#boxes_chart').data('fase1')}
        {label: $('#boxes_chart').data('label2') , value: $('#boxes_chart').data('fase2')}
        {label: $('#boxes_chart').data('label3') , value: $('#boxes_chart').data('fase3')}
        {label: $('#boxes_chart').data('label4') , value: $('#boxes_chart').data('fase4')}
        {label: $('#boxes_chart').data('label5') , value: $('#boxes_chart').data('fase5')}

      ],
      labelColor: '#34495e',
      colors: ['#18ccb9','#00b4cc','#128ecc','#2980B9', '#6b55ad'],






    Morris.Donut
      element: 'status_chart',
      data: [
        {label: 'Aberto' , value: $('#status_chart').data('aberto')}
        {label: 'Fechado' , value: $('#status_chart').data('fechado')}
        {label: 'Perdido' , value: $('#status_chart').data('perdido')}
      ]
      labelColor: '#34495e',
      colors: ['#18ccb9','#00b4cc','#128ecc','#2980B9', '#6b55ad']



    Morris.Donut
      element: 'volume_chart',
      data: [
        {label: $('#volume_chart').data('label1') , value: $('#volume_chart').data('fase1')}
        {label: $('#volume_chart').data('label2') , value: $('#volume_chart').data('fase2')}
        {label: $('#volume_chart').data('label3') , value: $('#volume_chart').data('fase3')}
        {label: $('#volume_chart').data('label4') , value: $('#volume_chart').data('fase4')}
        {label: $('#volume_chart').data('label5') , value: $('#volume_chart').data('fase5')}
      ]
      labelColor: '#34495e',
      colors: ['#18ccb9','#00b4cc','#128ecc','#2980B9', '#6b55ad']