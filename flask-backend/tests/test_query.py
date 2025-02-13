import requests

def test_prompt_api():
    url = "http://127.0.0.1:5000/prompt"
    payload = {"prompt": "Explain the theory of relativity. "}

    response = requests.post(url, json=payload)
    assert response.status_code == 200
    assert "response" in response.json()

if __name__ == '__main__':
    test_prompt_api()
    print("Test passed!")
