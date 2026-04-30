package com.github.stefvanschie.inventoryframework.pane;

import com.github.stefvanschie.inventoryframework.gui.GuiItem;
import com.github.stefvanschie.inventoryframework.gui.GuiComponent;
import com.github.stefvanschie.inventoryframework.gui.type.util.Gui;
import com.github.stefvanschie.inventoryframework.pane.util.GuiItemContainer;
import com.github.stefvanschie.inventoryframework.pane.util.Slot;
import org.bukkit.event.inventory.InventoryClickEvent;
import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NotNull;

/**
 * A pane for static items and stuff. All items will have to be specified a slot, or will be added in the next position.
 * <p>
 * This pane allows you to specify the positions of the items either in the form of an x and y coordinate pair or as an
 * index, in which case the indexing starts from the top left and continues to the right and bottom, with the horizontal
 * axis taking priority. There are nuances at play with regard to mixing these two types of positioning systems within
 * the same pane. It's recommended to only use one of these systems per pane and to not mix them.
 * </p>
 */
public class StaticNullablePane extends StaticPane {

    /**
     * Creates a new static nullable pane.
     *
     * @param length the length of the pane
     * @param height the height of the pane
     * @param priority the priority of the pane
     * @since 0.10.12
     */
    public StaticNullablePane(int length, int height, @NotNull Priority priority) {
        super(length, height, priority);
    }

    /**
     * Creates a new static nullable pane with normal priority.
     *
     * @param length the length of the pane
     * @param height the height of the pane
     * @since 0.10.12
     */
    public StaticNullablePane(int length, int height) {
        super(length, height);
    }

    @NotNull
    @Override
    public GuiItemContainer display() {
        return super.display();
    }

    @Override
    public boolean click(@NotNull Gui gui, @NotNull GuiComponent guiComponent,
                         @NotNull InventoryClickEvent event, @NotNull Slot slot) {
        int x = slot.getX(getLength());
        int y = slot.getY(getLength());

        if (x < 0 || x >= getLength() || y < 0 || y >= getHeight()) {
            return false;
        }

        callOnClick(event);

        GuiItem clickedItem = this.items.get(Slot.fromXY(x, y));
        if (clickedItem == null) {
            return false;
        }

        clickedItem.callAction(event);
        return true;
    }

    /**
     * Adds a rectangular area of the same GuiItem to the pane.
     * @param guiItem the item to add
     * @param startingX the starting x coordinate (north-west corner)
     * @param startingY the starting y coordinate (north-west corner)
     * @param xLength the length of the area
     * @param yLength the height of the area
     * @since 0.10.12
     */
    public void addItem(@NotNull GuiItem guiItem, int startingX, int startingY, int xLength, int yLength) {
        for (int i = startingX; i < startingX + xLength; i++) {
            for (int j = startingY; j < startingY + yLength; j++) {
                addItem(guiItem, i, j);
            }
        }
    }

    /**
     * Adds a rectangular area of the same GuiItem to the pane.
     * @param guiItem the item to add
     * @param slot the starting slot (north-west corner)
     * @param xLength the length of the area
     * @param yLength the height of the area
     * @since 0.10.12
     */
    public void addItem(@NotNull GuiItem guiItem, Slot slot, int xLength, int yLength) {
        addItem(guiItem, slot.getX(getLength()), slot.getY(getLength()), xLength, yLength);
    }

    /**
     * Adds a SQUARED area of the same GuiItem to the pane.
     * @param guiItem the item to add
     * @param startingX the starting x coordinate (north-west corner)
     * @param startingY the starting y coordinate (north-west corner)
     * @param length the length and height of the squared area
     * @since 0.10.12
     */
    public void addItem(@NotNull GuiItem guiItem, int startingX, int startingY, int length) {
        addItem(guiItem, startingX, startingY, length, length);
    }

    /**
     * Adds a SQUARED area of the same GuiItem to the pane.
     * @param guiItem the item to add
     * @param slot the starting slot (north-west corner)
     * @param length the length and height of the squared area
     * @since 0.10.12
     */
    public void addItem(@NotNull GuiItem guiItem, Slot slot, int length) {
        this.addItem(guiItem, slot, length, length);
    }
}
