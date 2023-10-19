# Pin npm packages by running ./bin/importmap

pin 'bootstrap', preload: true
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js', preload: true
pin "chart.js", to: "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js", preload: true

pin "application", preload: true

pin 'player/show', preload: true
pin 'home/distribution', preload: true