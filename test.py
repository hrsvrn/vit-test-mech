

import sys
from pathlib import Path
from PIL import Image
import torch
from transformers import ViTImageProcessor, ViTForImageClassification


def classify_image(image_path, model_name="google/vit-base-patch16-224", top_k=5):
    print(f"Loading model: {model_name}")
    
    # Load model and processor
    processor = ViTImageProcessor.from_pretrained(model_name)
    model = ViTForImageClassification.from_pretrained(model_name)
    
    # Use GPU if available
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    model.eval()
    
    print(f"Device: {device}")
    print(f"\nProcessing: {image_path}")
    
    # Load and preprocess image
    image = Image.open(image_path).convert('RGB')
    inputs = processor(images=image, return_tensors="pt")
    inputs = {k: v.to(device) for k, v in inputs.items()}
    
    # Run inference
    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits
    
    # Get predictions
    probs = torch.nn.functional.softmax(logits, dim=-1)
    top_probs, top_indices = torch.topk(probs, top_k)
    
    # Format results
    results = []
    for prob, idx in zip(top_probs[0], top_indices[0]):
        label = model.config.id2label[idx.item()]
        confidence = prob.item()
        results.append((label, confidence))
    
    return results


def main():
    if len(sys.argv) < 2:
        print("Usage: python demo.py <image_path> [top_k]")
        print("\nExample:")
        print("  python demo.py cat.jpg")
        print("  python demo.py cat.jpg 10")
        sys.exit(1)
    
    image_path = sys.argv[1]
    top_k = int(sys.argv[2]) if len(sys.argv) > 2 else 5
    
    # Validate image exists
    if not Path(image_path).exists():
        print(f"Error: Image not found: {image_path}")
        sys.exit(1)
    
    print("=" * 60)
    print("Vision Transformer Image Classification Demo")
    print("=" * 60)
    
    # Run classification
    results = classify_image(image_path, top_k=top_k)
    
    # Display results
    print(f"\nTop {top_k} Predictions:")
    print("-" * 60)
    for i, (label, confidence) in enumerate(results, 1):
        print(f"{i:2d}. {label:45s} {confidence*100:6.2f}%")
    print("=" * 60)


if __name__ == "__main__":
    main()

