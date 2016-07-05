'use strict';

/*global Paloma */

const EventsController = Paloma.controller('Events');

class CalendarEvent {
  constructor(start, end, description) {
    this.start = start;
    this.end = end;
    this.description = description;
  }
}

EventsController.prototype.index = () => {
  const weekStart = new Date($('#week-calendar').data('week'));
  const weekEnd = weekStart.addDays(6);
  const form = $('#event-form');

  const showErrors = (errors) => {
    form.find('.error').remove();
    for (let key in errors) {
      form.find(`.event_${key}`).append(
        $('<div class="error" />').text(errors[key].join('; '))
      );
    }
  };

  const clearForm = () => {
    form.find('form')[0].reset();
    form.find('textarea').val('');
    form.hide();
  };

  const eventDiv = (event) => {
    let days = event.end.daysDiff(event.start) + 1;
    return $('<div class="event-wrapper" />')
      .addClass(`span${days}`)
      .data('days', days)
      .append(
        $('<div class="event" />').append(
          $('<div class="description" />').text(event.description)
        )
      );
  };

  const parseEventDiv = (div, start) => {
    let description = div.find('.description').text();
    let end = start.addDays(parseInt(div.data('days'), 10) - 1);
    return new CalendarEvent(start, end, description);
  };

  const redrawEvents = () => {
    let days = $('.week-calendar .day');
    let events = {};
    days.each(function(i) {
      let day = weekStart.addDays(i);
      events[i] = $(this).find('.event-wrapper').map((j, div) => {
        return parseEventDiv($(div), day);
      });
    });
    $('.week-calendar').find('.event-wrapper').remove();
    $('.week-calendar').find('.event-span').remove();
    let slots = [];
    days.each(function(i) {
      let slot = 0;
      let day = weekStart.addDays(i);
      for (let j=0; j<slots.length; j++) {
        if (slots[j] && slots[j].end < day) { slots[j] = null; }
      }
      for (let ev of events[i]) {
        while (slots[slot]) {
          $(this).append('<div class="event-span" />');
          slot++;
        }
        slots[slot] = ev;
        slot++;
        $(this).append(eventDiv(ev));
      }
    });

  };

  $('<button>Cancel</button>')
    .insertBefore($('#event-form input[type="submit"]'))
    .click((e) => {
      e.preventDefault();
      form.hide();
    });
  $('#event-form').hide();
  $('#add-event-link').show().click(() => {
    form.show();
  });
  form.submit((e) => {
    e.preventDefault();
    $.post('/events', form.find('form').serialize(), (res) => {
      if (res.errors) { showErrors(res.errors); }
      else {
        clearForm();
        let evStart = new Date(res.start_date);
        let evEnd = new Date(res.end_date);
        if (evStart <= weekEnd && evEnd >= weekStart) {
          let start = new Date(Math.max.apply(null, [evStart, weekStart]));
          let end = new Date(Math.min.apply(null, [evEnd, weekEnd]));
          let event = new CalendarEvent(start, end, res.description);
          let div = eventDiv(event);
          let day = start.daysDiff(weekStart);
          div.appendTo($(`.week-calendar .day:nth-child(${day+1})`));
          redrawEvents();
        }
      }
    }, 'json');
  });
};
