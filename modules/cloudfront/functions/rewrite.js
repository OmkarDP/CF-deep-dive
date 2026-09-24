function handler(event) {
    var request = event.request;

    if (request.uri === "/home") {
        request.uri = "/index.html";
    }

    return request;
}