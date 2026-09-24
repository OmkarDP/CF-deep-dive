import cf from 'cloudfront';

const kvs = cf.kvs();

async function handler(event) {
    const request = event.request;

    let key = request.uri.replace("/", "");

    if (!key) {
        key = "global";
    }

    try {
        const value = await kvs.get(key);

        return {
            statusCode: 200,
            statusDescription: "OK",
            headers: {
                "content-type": {
                    value: "text/plain"
                }
            },
            body: value
        };

    } catch (err) {

        return {
            statusCode: 404,
            statusDescription: "Not Found",
            headers: {
                "content-type": {
                    value: "text/plain"
                }
            },
            body: "Key not found"
        };
    }
}