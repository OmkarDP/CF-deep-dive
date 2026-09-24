exports.handler = async (event) => {

    const request = event.Records[0].cf.request;

    const queryString = request.querystring;

    if (!queryString.includes("token=omkar123")) {

        return {
            status: '403',
            statusDescription: 'Forbidden',
            body: 'Access Denied'
        };
    }

    return request;
};