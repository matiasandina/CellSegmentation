library(dplyr)
library(psych)
library(ggplot2)

cells <- read.csv('./sample_data/sample_intensity/DAPI_01_intensity_cells.csv',
                  stringsAsFactors = F)


background <- read.csv('./sample_data/sample_intensity/DAPI_01_intensity_background.csv',
                                            stringsAsFactors = F)



cells$source <- 'cells'
background$source <- 'background'

df <- rbind(cells, background)

ggplot(df, aes(RawIntDen, fill=source)) +
  geom_histogram(color="white") +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(~source)

ggplot(df, aes(XM, YM, color=source)) +
  geom_point(alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  facet_wrap(~source)


ggplot(df, aes(XM,YM, color=log(RawIntDen)))+
  geom_point()+
  scale_color_gradient(low='black', high='red')+
  facet_wrap(~source)


summary_df <- df %>% group_by(source) %>%
              do(describe(.$RawIntDen)) %>%
              select(-vars)


total <- read.csv('./sample_data/sample_intensity/DAPI_01_intensity_total.csv',
                  stringsAsFactors = F)

# We should subtract from the total intensity the background!

total_background <- mean(background$RawIntDen) * total$Area/mean(background$Area)