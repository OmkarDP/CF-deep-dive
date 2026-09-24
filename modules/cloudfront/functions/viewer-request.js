function handler(event) {
    var request = event.request;

    request.headers["x-omkar-edge"] = { value: "cf-function" };
    if (!request.uri.includes(".")) {
        request.uri = "/index.html";
    }

    return request;
}