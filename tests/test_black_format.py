def test_function(x: int, y: int) -> int:
    """Test function for black formatting."""
    result = x + y
    return result


class TestClass:
    def __init__(self):
        self.value = 42

    def process_data(self, data: list[int]) -> list[int]:
        return [x * self.value for x in data]
