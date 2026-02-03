#!/usr/bin/env python3
import inkex
from inkex import Transform

DF_SHAPE_ID = "DF_SHAPE"
ARTWORK_INSERT_ID = "ARTWORK_INSERT"

class InstantiateArtwork(inkex.EffectExtension):

    def effect(self):
        df = self.svg.getElementById(DF_SHAPE_ID)
        insert = self.svg.getElementById(ARTWORK_INSERT_ID)

        imported = self.svg.selection.first()
        if imported is None:
            return

        insert.append(imported)

        df_bb = df.bounding_box(self.svg.composed_transform())
        art_bb = imported.bounding_box(self.svg.composed_transform())

        s = max(
            df_bb.width / art_bb.width,
            df_bb.height / art_bb.height
        )

        t = (
            Transform(f"translate({df_bb.center.x},{df_bb.center.y})")
            * Transform(f"scale({s})")
            * Transform(f"translate({-art_bb.center.x},{-art_bb.center.y})")
        )

        imported.transform = t * imported.transform

if __name__ == "__main__":
    InstantiateArtwork().run()
