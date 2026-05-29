   $(document).ready(function() {

    // page is now ready, initialize the calendar...
 
    $('#calendar').fullCalendar({
    	 
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      displayEventEnd: true,  // mostrar el fin del evento
      timeFormat: 'h(:mm) A', //formato am pm
      minTime: '11:00:00',    // para empezar a las 11 am
      allDaySlot : false,  //quitar all day
      hiddenDays: [ 0 ],  //quitar domingos


     views: {
        week: { 
          duration: { weeks: 2 }
        }
      },


      eventSources: [
        '/calendar_management/course_events.json'
      ],

      select: function(start, end) {
        $.getScript('/calendar_management/course_events/new', function() {
          $('.start_hidden').val(moment(end).format('DD-MM-YYYY HH:mm'));
          $('.end_hidden').val(moment(end).format('DD-MM-YYYY HH:mm'));
        });

 
      },

      eventClick: function(event, jsEvent, view) {
        $.getScript(event.edit_url, function() {
          $('.start_hidden').val(moment(event.start).format('DD-MM-YYYY HH:mm'));
          $('.end_hidden').val(moment(event.end).format('DD-MM-YYYY HH:mm'));
        });
      },

      eventRender: function(event, element) { 
        element.find('.fc-event-title').append( event.course_id); 
        element.find('.fc-event-title').append( '<br>'+ event.teacher_id);
        element.find('.fc-event-inner').css("background","url("+ event.teacher_avatar+ ") no-repeat right");
        element.find('.fc-event-inner').css("background-size","contain");
        element.find('.fc-event-inner').css("opacity","0.75");
      }

    })

});


 