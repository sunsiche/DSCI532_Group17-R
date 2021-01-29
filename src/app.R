library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(purrr)
source("data_manager.R")

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
  dbcContainer(
    list(
      htmlBr(),
      dbcRow(
        list(
          dbcCol(
            list(
              htmlDiv(
                id='placebolder-left',
                style={'height': '20vh'}
                ),
              htmlDiv('Rank By:'),
              dccDropdown(
                id='rankby-widget',
                value='Overall',
                options=(data %>% colnames) %>% map(function(col) list(label = col, value = col))
                ),
              htmlBr(),
              htmlDiv('Order:'),
              dccDropdown(
                id='order-widget',
                value='True',
                options=list(list(label = 'Descending', value =  'False'),
                             list(label = 'Ascending', value = 'True'))
                ),
              htmlBr(),
              htmlDiv('Continent:'),
              dccDropdown(
                id='filter-cont-widget',
                value='',
                options=map(unique(data$Continent), function(val) list(label = val, value= val))
                ),
              htmlBr(),
              htmlDiv('Club:'),
              dccDropdown(
                id='filter-club-widget',
                value='',
                options=map(unique(data$Club), function(val) list(label = val, value= val))
                )
              ), md=3),
          dbcCol(
            list(
              htmlH1('FIFA STAR BOARD', style=list(width= '50vh', height= '10vh')),
              htmlH4('Select Attributes:'),
              dccDropdown(
                id='attribute-widget',
                value=list('Name', 'Nationality', 'Age', 'Value(???)', 'Overall'),
                options=(data %>% colnames) %>% map(function(col) list(label = col, value = col)),
                multi=True
                ),
              dccGraph(
                id='table',
                style=list('border-width'= '0', 'width' = '100%', 'height' = '500px')
                ),
              )),
         dbcCol(
           list(
             htmlDiv(
               id='placebolder-right',
               style={'height': '10vh'}
               ),
             htmlDiv('Top 10 by Club and by Nationality'),
             dccGraph(
               id='charts',
               style=list('border-width'= '0', 'width' = '150%', 'height' = '700px')
               ),
           ), md=3)
          )))))
    
# updates table from all 5 dropdowns
app$callback(
  output(id = 'table', property = 'figure'),
  list(input('rankby-widget', 'value'),
       input('order-widget', 'value'),
       input('attribute-widget', 'value'),
       input('filter-cont-widget', 'value'),
       input('filter-club-widget', 'value')),
  function(by, order, cols, filter_cont, filter_club){
    update_table(data, by, order == "True", cols, filter_cont, filter_club)
    
  }
)




# updates charts with Rank-by selection 
# updates only when selected col is numeric
app$callback(
  output(id = 'charts', property = 'figure'),
  list(input('rankby-widget', 'value')),
  function(by){
    if (is_numeric(data$by) == FALSE){
      return charts
    } else{
      plot_altair(data, by=by)
    }
    
  }
)




app$run_server(debug = T)