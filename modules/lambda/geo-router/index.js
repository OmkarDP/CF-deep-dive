exports.handler = async (event) => {

    const request = event.Records[0].cf.request;

    console.log(JSON.stringify(request.headers));

    const country =
        request.headers["cloudfront-viewer-country"];

    if (country) {

        console.log(country[0].value);

        if (country[0].value === "IN") {

            request.uri = "/lang/mr.html";
        }

        else if (country[0].value === "US") {

            request.uri = "/lang/en.html";
        }
    }

    return request;
}