import { render, screen, fireEvent } from "@testing-library/react";
import AddItemForm from "./AddItemForm";
import { vi } from "vitest";
import { useAppReducer } from "../AppContext.jsx";

vi.mock("../AppContext.jsx", () => ({
  useAppReducer: vi.fn(),
}));

describe("AddItemForm", () => {
  let mockDispatch;

  beforeEach(() => {
    mockDispatch = vi.fn();
    useAppReducer.mockReturnValue(mockDispatch);
  });

  it("renders the form correctly", () => {
    render(<AddItemForm />);

    // Pastikan input dan tombol dirender
    expect(screen.getByPlaceholderText("Add new item")).toBeInTheDocument();
    expect(screen.getByRole("button")).toBeInTheDocument();
  });

  it("dispatches the correct action when a valid item is added", () => {
    render(<AddItemForm />);
    const input = screen.getByPlaceholderText("Add new item");
    const button = screen.getByRole("button");

    // Isi input dengan teks
    fireEvent.change(input, { target: { value: "New Todo" } });
    fireEvent.click(button);

    // Periksa apakah dispatch dipanggil dengan benar
    expect(mockDispatch).toHaveBeenCalledWith({
      type: "ADD_ITEM",
      item: expect.objectContaining({
        text: "New Todo",
        status: "pending",
      }),
    });
  });

  it("does not dispatch if input is empty", () => {
    render(<AddItemForm />);
    const button = screen.getByRole("button");

    // Klik tombol tanpa mengisi input
    fireEvent.click(button);

    // Periksa apakah dispatch tidak dipanggil
    expect(mockDispatch).not.toHaveBeenCalled();
  });

  it("clears and refocuses the input after adding an item", () => {
    render(<AddItemForm />);
    const input = screen.getByPlaceholderText("Add new item");
    const button = screen.getByRole("button");

    fireEvent.change(input, { target: { value: "New Todo" } });
    fireEvent.click(button);

    // Pastikan input dikosongkan dan difokuskan ulang
    expect(input.value).toBe("");
    expect(document.activeElement).toBe(input);
  });
});
