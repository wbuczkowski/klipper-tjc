from dataclasses import dataclass
from typing import Any, Callable

@dataclass
class Response():

    callback_function : Callable[[bytes], Any]
    response_data : bytes = bytes()
