// Añadir a la clase AIApi

func sentiment(text: String, completion: @escaping (String) -> Void) {
    let prompt = "Analiza el siguiente titular sobre criptomonedas e indica si es positivo, negativo o neutral: \(text)"
    // ... igual que arriba, pero cambiando el prompt ...
    // Al recibir la respuesta, haz completion("positivo"), completion("negativo") o completion("neutral")
}