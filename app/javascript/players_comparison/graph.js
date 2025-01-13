import "chart.js"

let PlayersComparisonChart = null;

function createGraph() {
  if (PlayersComparisonChart) {
    PlayersComparisonChart.destroy();
  }
  let players_records = $('#playersComparisonChart').data('players-records');
  let dates = $('#playersComparisonChart').data('dates');
  let minRating = parseInt($('#ratingMin').val());
  let maxRating = parseInt($('#ratingMax').val());

  let graphData = [];
  const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
  for (let i = 0; i < players_records.length; i++) {
    const ratings = [];
    let lastRating = 0;
    for (let j = 0; j < dates.length; j++) {
      if (players_records[i]['ratings'][dates[j]]) {
        ratings.push(players_records[i]['ratings'][dates[j]]);
        lastRating = players_records[i]['ratings'][dates[j]];
      }else{
        ratings.push(null);
      }
    }
    let data = {
      label: players_records[i]['name'],
      data: ratings,
      spanGaps: true,
      fill: false,
      hidden: lastRating < minRating || lastRating > maxRating,
      borderColor: `hsl(${i * 360 / players_records.length}, 70%, 50%)`,  // 色相を均等に分配
      backgroundColor: `hsl(${i * 360 / players_records.length}, 70%, 50%)`,  // 同じ色を背景にも設定
      segment: {
        borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
        borderDash: ctx => skipped(ctx, [6, 6]),
      },
    }
    graphData.push(data);
  }

  const data = {
    labels: dates,
    datasets: graphData
  };

  const config = {
    type: 'line',
    data,
    options: {
      responsive: true,
      scales: {
        y: {
          axis: 'r'
        }
      }
    }
  };

  PlayersComparisonChart = new Chart(
    document.getElementById('playersComparisonChart'),
    config
  );
}

document.getElementById('ratingMin').addEventListener('change', (e) => {
  createGraph();
});

document.getElementById('ratingMax').addEventListener('change', (e) => {
  createGraph();
});

document.addEventListener('DOMContentLoaded', () => {
  createGraph();
});