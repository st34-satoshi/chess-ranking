import "application"
import "chart.js"

function createRatingGraph(){
    let records = $('#ratingChart').data('record');
    let dates = $('#ratingChart').data('date');
    const series = [
      { key: 'standard_rating', label: $('#ratingChart').data('standard-label'), color: 'rgb(36, 140, 140)' },
      { key: 'rapid_rating', label: $('#ratingChart').data('rapid-label'), color: 'rgb(205, 112, 28)' }
    ];
    const datasets = series.map(({ key, label, color }) => ({
      label,
      backgroundColor: color,
      borderColor: color,
      data: dates.map(date => records[date]?.[key] ?? null),
      segment: {
        borderDash: ctx => ctx.p0.skip || ctx.p1.skip ? [6, 6] : undefined,
      },
      spanGaps: true,
      fill: false
    }));
    const hasRatings = datasets.some(dataset => dataset.data.some(value => value !== null));
    if (!hasRatings) {
      $('#ratingChart').hide();
      $('#ratingNoData').removeClass('d-none');
      return;
    }
    const data = { labels: dates, datasets };

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
        label: $('#rankChart').data('label'),
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