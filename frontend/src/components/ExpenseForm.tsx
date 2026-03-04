/**
 * Form component for adding/editing expenses
 */

import React from "react";
import { ExpenseFormData } from "../types";
import { TextField, SelectBox, Button } from "../vibes";
import { useExpenseForm } from "../hooks/useExpenseForm";
import { fetchCategories, createCategory } from "../services/api";

interface ExpenseFormProps {
  initialData?: Partial<ExpenseFormData>;
  onSubmit: (data: ExpenseFormData) => Promise<void>;
  onCancel?: () => void;
  submitLabel?: string;
}

export function ExpenseForm({
  initialData,
  onSubmit,
  onCancel,
  submitLabel = "Add Expense",
}: ExpenseFormProps) {
  const { formData, errors, isSubmitting, handleChange, handleSubmit } =
    useExpenseForm({
      initialData,
      onSubmit,
    });

  const [categoryOptions, setCategoryOptions] = React.useState<
    { value: string; label: string; id: number }[]
  >([]);

  React.useEffect(() => {
    fetchCategories()
      .then((data) => {
        setCategoryOptions(
          data.map((c) => ({
            value: c.name,
            label: c.name,
            id: c.id,
          })),
        );
      })
      .catch((err) => console.error("Failed to fetch categories:", err));
  }, []);

  const handleAddCategory = async () => {
    const name = prompt("Enter new category name");
    if (!name) return;

    try {
      const newCategory = await createCategory(name);
      setCategoryOptions((prev) => [
        ...prev,
        {
          value: newCategory.name,
          label: newCategory.name,
          id: newCategory.id,
        },
      ]);
      handleChange("category", newCategory.name);
    } catch (err) {
      console.error("Failed to create category:", err);
      alert("Failed to create category. Maybe the name already exists?");
    }
  };

  const formStyle: React.CSSProperties = {
    display: "flex",
    flexDirection: "column",
    gap: "1rem",
  };

  const buttonGroupStyle: React.CSSProperties = {
    display: "flex",
    gap: "0.5rem",
    marginTop: "0.5rem",
  };

  const textButtonStyle: React.CSSProperties = {
    background: "transparent",
    color: "#007bff",
    padding: 0,
    height: "auto",
    minWidth: 0,
    alignSelf: "flex-start",
    fontSize: "0.9rem",
    border: "none",
    margin: "0",
    cursor: "pointer",
  };

  return (
    <form onSubmit={handleSubmit} style={formStyle}>
      <TextField
        label="Amount"
        type="number"
        step="0.01"
        placeholder="0.00"
        value={formData.amount}
        onChange={(e) => handleChange("amount", e.target.value)}
        error={errors.amount}
        fullWidth
        required
      />

      <TextField
        label="Description"
        type="text"
        placeholder="Enter description"
        value={formData.description}
        onChange={(e) => handleChange("description", e.target.value)}
        error={errors.description}
        fullWidth
        required
      />

      <SelectBox
        label="Category"
        options={categoryOptions}
        value={formData.category}
        onChange={(e) => handleChange("category", e.target.value)}
        error={errors.category}
        fullWidth
        required
      />

      <Button
        type="button"
        variant="secondary"
        onClick={handleAddCategory}
        style={textButtonStyle}
      >
        Add Category
      </Button>

      <TextField
        label="Date"
        type="date"
        value={formData.date}
        onChange={(e) => handleChange("date", e.target.value)}
        error={errors.date}
        fullWidth
        required
      />

      <div style={buttonGroupStyle}>
        <Button
          type="submit"
          variant="primary"
          disabled={isSubmitting}
          fullWidth
        >
          {isSubmitting ? "Submitting..." : submitLabel}
        </Button>
        {onCancel && (
          <Button
            type="button"
            variant="secondary"
            onClick={onCancel}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
        )}
      </div>
    </form>
  );
}
