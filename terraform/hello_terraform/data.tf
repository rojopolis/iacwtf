data "null_data_source" "greetings" {
    inputs = {
        hello = "Hello."
        goodbye = "Goodbye."
    }
}