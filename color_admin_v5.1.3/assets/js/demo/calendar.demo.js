/*
Template Name: Color Admin - Responsive Admin Dashboard Template build with Twitter Bootstrap 5
Version: 5.1.3
Author: Sean Ngu
Website: http://www.seantheme.com/color-admin/
*/

var handleCalendarDemo = function() {
	 
  // fullcalendar
  
  var d = new Date();
	var month = d.getMonth() + 1;
	    month = (month < 10) ? '0' + month : month;
	var year = d.getFullYear();
	var day = d.getDate();
	var today = moment().startOf('day');
  var calendarElm = document.getElementById('calendar');
	var calendar = new FullCalendar.Calendar(calendarElm, {
    headerToolbar: {
      left: 'dayGridMonth,timeGridWeek,timeGridDay',
      center: 'title',
      right: 'prev,next today'
    },
    buttonText: {
    	today:    'Hoy',
			month:    'Mes',
			week:     'Semana',
			day:      'Dia'
    },
    initialView: 'dayGridMonth',
   // selectable: true,
    //selectHelper: true,
    //editable: true,
    eventLimit: true,
    displayEventEnd: true,  // mostrar el fin del evento
    timeFormat: 'h(:mm) AP', //formato am pm
    minTime: '11:00:00',    // para empezar a las 11 am
    allDaySlot : false,  //quitar all day
 
    themeSystem: 'bootstrap',
    views: {
      timeGrid: {
        eventLimit: 6 // adjust to 6 only for timeGridWeek/timeGridDay
      }
    },

      events:  '/calendar_management/meet_events.json',

      select: function(start, end) {
        $.getScript('/calendar_management/meet_events/new', function() {
         
        });

 
      },

      eventDrop: function(event, delta, revertFunc) {
        event_data = { 
          event: {
            id: event.id,
            start: event.start.format(),
            end: event.end.format()
          }
        };
        $.ajax({
            url: event.update_url,
            data: event_data,
            type: 'PATCH'
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
   
  });
  
	calendar.render();
};

var Calendar = function () {
	"use strict";
	return {
		//main function
		init: function () {
			handleCalendarDemo();
		}
	};
}();

$(document).ready(function() {
	Calendar.init();
});