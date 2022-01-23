function createGraph(){
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
        spanGaps: true
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

$(function() {
    createGraph();
});