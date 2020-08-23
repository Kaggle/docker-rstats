context("keras")

test_that("model training", {
    library(keras)
    physical_devices = tensorflow::tf$config$list_physical_devices('GPU')
    tensorflow::tf$config$experimental$set_memory_growth(physical_devices[[1]],T)
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

test_that("CNN model training", {
    library(keras)
    physical_devices = tensorflow::tf$config$list_physical_devices('GPU')
    tensorflow::tf$config$experimental$set_memory_growth(physical_devices[[1]],T)
    # Preprocess data
    train.label<- to_categorical(matrix(sample(0:9, 100, TRUE), ncol = 1), 10)
    train.feature<- matrix(sample(0:255, 28 * 28 * 100, TRUE), nrow = 100)
    dim(train.feature)<-c(nrow(train.feature), 28, 28, 1)

    # Build simple CNN
    model<-keras_model_sequential()

    model %>% 
        layer_conv_2d(filters = 32, kernel_size = c(5,5),padding = 'Valid', activation = 'relu', input_shape = c(28,28,1)) %>%
        layer_batch_normalization() %>%
        layer_conv_2d(filters = 32, kernel_size = c(5,5),padding = 'Same', activation = 'relu') %>%
        layer_batch_normalization() %>%
        layer_max_pooling_2d(pool_size = c(2, 2)) %>%
        layer_dropout(rate = 0.2) %>%
        layer_conv_2d(filters = 64, kernel_size = c(3,3),padding = 'Same', activation = 'relu') %>%
        layer_batch_normalization()%>%
        layer_conv_2d(filters = 64, kernel_size = c(3,3),padding = 'Same', activation = 'relu') %>%
        layer_batch_normalization() %>%
        layer_max_pooling_2d(pool_size = c(2, 2)) %>%
        layer_dropout(rate = 0.2) %>%
        layer_flatten() %>%
        layer_dense(units=1024,activation='relu') %>%
        layer_dense(units=512,activation='relu') %>%
        layer_dense(units=256,activation='relu') %>%
        layer_dense(units=10,activation='softmax')  

    model %>% compile(
        loss='categorical_crossentropy',
        optimizer='adam',
        metrics='accuracy'
    )

    # Train model
    datagen <- image_data_generator(
        featurewise_center = F,
        samplewise_center=F,
        featurewise_std_normalization = F,
        samplewise_std_normalization=F,
        zca_whitening=F,
        horizontal_flip = F,
        vertical_flip = F,
        width_shift_range = 0.15,
        height_shift_range = 0.15,
        zoom_range = 0.15,
        rotation_range = 0.15,
        shear_range = 0.15
    )

    datagen %>% fit_image_data_generator(train.feature)

    history <- model %>%
        fit_generator(
            flow_images_from_data(train.feature, train.label, datagen, batch_size = 10),
            steps_per_epoch = nrow(train.feature) / 10,
            epochs = 1)

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
