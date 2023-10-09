import "application"
import "chart.js"

function createRatingGraph(){
    let records = $('#ratingChart').data('record');
    let dates = $('#ratingChart').data('date');
    let ratings = [];
    dates.forEach(function(date){
      let rating = NaN;
      if (date in records){
        rating = records[date]['rating'];
      }
      ratings.push(rating);
    });

    const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
    const data = {
      labels: dates,
      datasets: [{
        label: 'Rating',
        backgroundColor: 'rgb(75, 192, 192)',
        borderColor: 'rgb(75, 192, 192)',
        data: ratings,
        segment: {
          borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
          borderDash: ctx => skipped(ctx, [6, 6]),
        },
        spanGaps: true,
        fill: false
      }]
    };

    const config = {
      type: 'line',
      data,
      options: {}
    };

    var ratingChart = new Chart(
      document.getElementById('ratingChart'),
      config
    );
}

function createRankGraph(){
    let records = $('#rankChart').data('record');
    let dates = $('#rankChart').data('date');
    let rankings = [];
    dates.forEach(function(date){
      let rank = NaN;
      if (date in records){
        rank = records[date]['rank'];
      }
      rankings.push(rank);
    });

    const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
    const data = {
      labels: dates,
      datasets: [{
        label: 'Ranking',
        backgroundColor: 'rgb(192,75,75)',
        borderColor: 'rgb(192,75,75)',
        data: rankings,
        segment: {
          borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
          borderDash: ctx => skipped(ctx, [6, 6]),
        },
        spanGaps: true,
        fill: false
      }]
    };

    const config = {
      type: 'line',
      data,
      options: {
          scales: {
            y: {
              reverse: true,
              axis: 'r'
            }
          }
        }
    };

    var rankingChart = new Chart(
      document.getElementById('rankChart'),
      config
    );
}

$(function() {
    createRatingGraph();
    createRankGraph();
});