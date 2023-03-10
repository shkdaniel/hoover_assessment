import requests
import pytest

from pytest_bdd import scenario, given, then, parsers

EXTRA_TYPES = {
    'Number': int,
    'String': str,
    'Eval': eval,
}

# Shared Variables
url = "http://localhost:8080/v1/cleaning-sessions"


# Scenarios
@scenario('../features/hoover_service.feature', 'Basic API functionality')
def test_api():
    pass


# Given Steps
@pytest.fixture()
@given(parsers.cfparse('the hoover API is posted with data {roomSize:Eval}, '
                       '{coords:Eval}, {patches:Eval} and {instructions:String}',
                       extra_types=EXTRA_TYPES), target_fixture='service_response')
def service_response(roomSize, coords, patches, instructions):
    data = {
        "roomSize": roomSize,
        "coords": coords,
        "patches": patches,
        "instructions": instructions
    }
    headers = {"Content-Type": "application/json"}
    return requests.post(url, json=data, headers=headers)


# Then Steps
@then(parsers.parse('the response status code is "{statusCode:Number}"', extra_types=EXTRA_TYPES))
def service_response_code(service_response, statusCode):
    assert service_response.status_code == statusCode


@then(parsers.parse('the response contains results for "{coordsFinal:Eval}" and "{patchesCount:Number}"', extra_types=EXTRA_TYPES))
def service_response_contents(service_response, coordsFinal, patchesCount):
    if len(service_response.text) > 0:
        try:
            if service_response.json()['status'] != 200:
                print(service_response.json()['message'])
        except KeyError:
            assert coordsFinal == service_response.json()['coords']
            assert patchesCount == service_response.json()['patches']



