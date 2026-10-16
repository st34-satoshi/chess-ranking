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
    const series = [
      { key: 'standard_rank', label: $('#rankChart').data('standard-label'), color: 'rgb(36, 140, 140)' },
      { key: 'rapid_rank', label: $('#rankChart').data('rapid-label'), color: 'rgb(205, 112, 28)' }
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
    const hasRanks = datasets.some(dataset => dataset.data.some(value => value !== null));
    if (!hasRanks) {
      $('#rankChart').hide();
      $('#rankNoData').removeClass('d-none');
      return;
    }
    const data = { labels: dates, datasets };

    const config = {
      type: 'line',
      data,
      options: {
          scales: {
            y: {
              reverse: true,
              min: 1,
              ticks: { precision: 0 }
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