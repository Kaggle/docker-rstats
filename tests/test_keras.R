context("keras")

test_that("model training", {
    library("keras")

    x_train <- matrix(rnorm(100 * 10), nrow = 100)
    y_train <- to_categorical(matrix(sample(0:2, 100, TRUE), ncol = 1), 3)

    model <- keras_model_sequential()
    model %>%
        layer_dense(units=100, activation='relu', input_shape=dim(x_train)[2]) %>%
        layer_dropout(rate=0.4) %>%
        layer_dense(unit=3, activation='softmax')

    model %>% compile(
        loss = 'categorical_crossentropy',
        optimizer = optimizer_rmsprop(),
        metrics = c('accuracy')
    )

    history <- model %>% fit(
        x_train, y_train,
        epochs=5, batch_size = 8,
        validation_split=0.2
    )

    expect_is(history, "keras_training_history")
})

test_that("flow_images_from_dataframe", {
    library(keras)
    library(readr)

    base_dir <- '/input/tests/data'
    test_labels <- read_csv("/input/tests/data/sample_submission.csv")

    test_labels$filename <- paste0(test_labels$id_code, ".png")

    pred <- flow_images_from_dataframe(
        dataframe = test_labels,
        x_col = "filename",
        y_col = NULL,
        directory = base_dir,
        shuffle = FALSE,
        class_mode = NULL,
        target_size = c(224, 224))

    expect_is(pred, "keras_preprocessing.image.dataframe_iterator.DataFrameIterator")
})
