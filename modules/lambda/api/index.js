exports.handler = async () => {
    return {
      statusCode: 200,
      headers: {
        "Cache-Control": "no-store",
        "x-omkar-origin": "lambda-api"
      },
      body: JSON.stringify({
        message: "Hello Omkar 🚀",
        time: new Date()
      })
    };
  };